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

class CartViewModel {
    private let repository: AppRepository! // di
    private let contactStore: CNContactStore! // di
    
    init(repository: AppRepository?, contactStore: CNContactStore?) {
        self.repository = repository
        self.contactStore = contactStore
    }
    
    /** Current products in dataSource */
//    private let _products = ReplaySubject<[Product]>.create(bufferSize: 1)
    
    func products() -> Observable<Event<CoreDataSourceTableView<Product>>> {
        repository.products(
            predicate: NSPredicate(format: "inCart.@count != 0"),
            cellId: "product"
        )
    }
    
    private lazy var __products = repository.products(predicate: NSPredicate(format: "inCart.@count != 0")).share(replay: 1, scope: .forever)
    
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
        return Observable.zip(order, sum).map { $0.0 + $0.1 }
    }
    
    func inCartCount() -> Observable<String?> {
        __products.map {
            if $0.isEmpty { return nil }
            return String($0.count)
        }
    }
    
    func clearCart() -> Result<Void, Error> {
        repository.clearCart()
    }
    
    private lazy var orderWarning = repository.orderWarning()
    
    func warning() -> Observable<Event<String>> {
        orderWarning.dematerialize().map { $0.first?.text ?? "" }.materialize()
    }
    
    func withWarning() -> Observable<Bool> {
        orderWarning.dematerialize()
            .compactMap { $0.first?.groups }
            .flatMap { [weak self] groups -> Observable<Bool> in
                self?.__products.map { products in
                    products.first { groups.contains($0.group?.name ?? "") } == nil
                } ?? Observable.empty()
            }
    }
    
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
                    // Find contact by phone
                    let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phone))
                    return self?.contactStore.rx.unifiedContacts(
                        matching: predicate,
                        keysToFetch: [CNContactGivenNameKey] as [CNKeyDescriptor]
                    ).flatMap { contacts -> Observable<Void> in
                        // If not found add
                        if contacts.isEmpty {
                            // Create a new contact
                            let newContact = CNMutableContact()
                            newContact.givenName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
                            newContact.phoneNumbers = [CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: phone))]
                            // Save the contact
                            let saveRequest = CNSaveRequest()
                            saveRequest.add(newContact, toContainerWithIdentifier: nil)
                            try self?.contactStore.execute(saveRequest)
                        }
                        return Observable.just(())
                    } ?? Observable.empty()
                }
                return Observable.just(())
            }
    }
}
