//
//  CartViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 29.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Contacts

protocol CartViewModel {
    /** DataSource with products */
    func products() -> Observable<Event<CoreDataSourceTableView<Product>>>
    /** Sum for order */
    func totalInCart() -> Observable<Int>
    /** Message for order */
    func message() -> Observable<String>
    /** Count of products in cart */
    func inCartCount() -> Observable<String?>
    /** Remove all products from cart */
    func clearCart() -> Result<Void, Error>
    /** Warning text for order */
    func warning() -> Observable<Event<String>>
    /** Check need the warning for order */
    func withoutWarning() -> Observable<Bool>
    /** - Returns: Phone for order */
    func phoneForOrder() -> Observable<Event<String>>
    /** Find phone for order in contacts. Add it if needed */
    func checkContact(phone: String) -> Observable<Void>
}

class CartViewModelImpl: CartViewModel {
    private let repository: Repository! // di
    private let contactStore: CNContactStore! // di
    
    init(repository: Repository?, contactStore: CNContactStore?) {
        self.repository = repository
        self.contactStore = contactStore
    }
        
    // MARK: - Products
    /** DataSource with products */
    func products() -> Observable<Event<CoreDataSourceTableView<Product>>> {
        repository.products(
            predicate: NSPredicate(format: "inCart.@count != 0"),
            cellId: "product"
        )
    }
    
    /** Observable [Product] for cart methods */
    private lazy var __products = repository.products(predicate: NSPredicate(format: "inCart.@count != 0")).share(replay: 1, scope: .forever)
    
    // MARK: - Cart
    /** Sum for order */
    func totalInCart() -> Observable<Int> {
        __products.map { $0.map { $0.priceSumInCart() }.reduce(0, +) }
    }
    /** Message for order */
    func message() -> Observable<String> {
        let order = __products.take(1).map {
            $0.map { $0.textForOrder() }.joined(separator: ", \r\n") + "\r\n"
        }
        let sum = totalInCart().take(1).map { "Total: \($0) rub." }
        let delivery = repository.profile().take(1).compactMap { $0.first?.delivery() }.ifEmpty(default: "")
        return Observable.zip(order, sum, delivery).map { $0.0 + $0.1 + $0.2 }
    }
    /** Count of products in cart */
    func inCartCount() -> Observable<String?> {
        __products.map {
            if $0.isEmpty { return nil }
            return String($0.count)
        }
    }
    /** Remove all products from cart */
    func clearCart() -> Result<Void, Error> {
        repository.clearCart()
    }
    
    // MARK: - Order warning
    private lazy var orderWarning = repository.orderWarning()
    
    /** Warning text for order */
    func warning() -> Observable<Event<String>> {
        orderWarning.dematerialize().map { $0.first?.text ?? "" }.materialize()
    }
    /** Check need the warning for order */
    func withoutWarning() -> Observable<Bool> {
        orderWarning.dematerialize()
            .compactMap { $0.first?.groups }
            .flatMap { [weak self] groups -> Observable<Bool> in
                self?.__products.map { products in
                    products.first { groups.contains($0.group?.name ?? "") } == nil
                } ?? Observable.empty()
            }
    }
    
    // MARK: - Phone
    /** - Returns: Phone for order */
    func phoneForOrder() -> Observable<Event<String>> {
        repository.sellerContacts().dematerialize().compactMap {
            $0.first?.phone
        }.materialize().take(1)
    }
    
    /** Find phone for order in contacts. Add it if needed */
    func checkContact(phone: String) -> Observable<Void> {
        contactStore.rx.requestAccess(for: .contacts)
            .flatMap { [weak self] access -> Observable<Void> in
                if access {
                    // Find contact by phone & add it if not found
                    return self?.findContact(phone)
                        .flatMap { contacts -> Observable<Void> in
                            // If not found add
                            if contacts.isEmpty {
                                try self?.addContact(phone)
                            }
                            return Observable.just(())
                        } ?? Observable.empty()
                }
                return Observable.just(())
            }
    }
    
    /** Find contact by phone */
    private func findContact(_ phone: String) -> Observable<[CNContact]> {
        // Predicate by phone
        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phone))
        // Find contacts with predicate
        return contactStore.rx.unifiedContacts(
            matching: predicate,
            keysToFetch: [CNContactGivenNameKey] as [CNKeyDescriptor]
        )
    }
    /** Add contact with app name & phone number */
    private func addContact(_ phone: String) throws {
        // Create a new contact
        let newContact = CNMutableContact()
        newContact.givenName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        newContact.phoneNumbers = [CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: phone))]
        // Save the contact
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier: nil)
        try contactStore.execute(saveRequest)
    }
}
