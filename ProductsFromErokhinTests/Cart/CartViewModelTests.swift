//
//  CartViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import Contacts
@testable import ProductsFromErokhin

class CartViewModelTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var repository: RepositoryMock!
    private var viewModel: CartViewModel!
    private var contactStore: CNContactStoreMock!
    private var products = [Product]()
    private var orderWarning = [OrderWarning]()
    private var sellerContacts = [SellerContacts]()
    private var profile: Profile!

    override func setUpWithError() throws {
        // Product with sum 10 * 1
        let product1 = { () -> Product in
            let product = Product(context: self.context)
            product.name = "product1"
            product.price = 10
            _ = product.addToCart()
            return product
        }()
        // Product with sum 10 * 2
        let product2 = { () -> Product in
            let product = Product(context: self.context)
            product.name = "product2"
            product.price = 10
            _ = product.addToCart()
            _ = product.addToCart()
            return product
        }()
        // Product with sum 10 * 3
        let product3 = { () -> Product in
            let product = Product(context: self.context)
            product.name = "product2"
            product.price = 10
            _ = product.addToCart()
            _ = product.addToCart()
            _ = product.addToCart()
            return product
        }()
        // Products with total sum == 60
        products = [product1, product2, product3]
        // Warning for group
        orderWarning = { () -> [OrderWarning] in
            let warning = OrderWarning(context: context)
            warning.text = "text"
            warning.groups = ["group"]
            return [warning]
        }()
        
        sellerContacts = { () -> [SellerContacts] in
            let contact = SellerContacts(context: context)
            contact.phone = "phone"
            contact.address = "address"
            return [contact]
        }()
        
        profile = { () -> Profile in
            let profile = Profile(context: context)
            profile.name = "name"
            profile.phone = "phone"
            profile.address = "address"
            return profile
        }()
        
        repository = RepositoryMock()
        contactStore = CNContactStoreMock()
        viewModel = CartViewModelImpl(repository: repository, contactStore: contactStore)
    }
    
    override func tearDownWithError() throws {
        try Product.clearEntity(context: context)
        try ProductInCart.clearEntity(context: context)
        try OrderWarning.clearEntity(context: context)
        try SellerContacts.clearEntity(context: context)
        try Profile.clearEntity(context: context)
    }
    
    func testProducts() {
        XCTAssertNil(repository.predicateProductsTableView)
        XCTAssertNil(repository.cellIdProductsTableView)
        XCTAssertEqual(try viewModel.products().toBlocking().first()?.element, repository.productsResultTableView)
        XCTAssertNotNil(repository.predicateProductsTableView)
        XCTAssertNotNil(repository.cellIdProductsTableView)
    }
    
    func testTotalInCart() {
        repository.productResult = products
        XCTAssertEqual(try viewModel.totalInCart().toBlocking().first(), 60)
    }
    
    func testMessage() throws {
        repository.productResult = products
        repository.profileResult.append(profile)
        let result = try viewModel.message().toBlocking().first()
        products.forEach {
            XCTAssertTrue(result!.contains($0.textForOrder()))
        }
        XCTAssertTrue(result!.contains("60"))
        XCTAssertTrue(result!.contains(profile.delivery()))
    }
    
    func testInCartCountEmpty() {
        XCTAssertNil(try viewModel.inCartCount().toBlocking().first()!)
    }
    
    func testInCartCountNotEmpty() {
        repository.productResult = products
        XCTAssertEqual(try viewModel.inCartCount().toBlocking().first()!, String(products.count))
    }
    
    func testClearCart() {
        XCTAssertFalse(repository.isClearCart)
        XCTAssertNoThrow(try viewModel.clearCart().toBlocking().first())
        XCTAssertTrue(repository.isClearCart)
    }
    
    func testWarning() {
        repository.orderWarningResult = orderWarning
        XCTAssertEqual(try viewModel.warning().dematerialize().toBlocking().first(), orderWarning.first?.text)
    }
    
    func testWithoutWarningTrue() {
        repository.productResult = products
        repository.orderWarningResult = orderWarning
        XCTAssertTrue(try viewModel.withoutWarning().toBlocking().first()!)
    }
    
    func testWithoutWarningFalse() {
        let group = Group(context: context)
        group.name = "group"
        products.first?.group = group
        repository.productResult = products
        repository.orderWarningResult = orderWarning
        XCTAssertFalse(try viewModel.withoutWarning().toBlocking().first()!)
    }
    
    func testPhoneForOrder() {
        repository.sellerContactsResult = sellerContacts
        XCTAssertEqual(try viewModel.phoneForOrder().dematerialize().toBlocking().first(), sellerContacts.first?.phone)
    }
    
    func testCheckContact() {
        let disposeBag = DisposeBag()
        // Doesn't access
        XCTAssertNil(contactStore.predicate)
        XCTAssertNil(contactStore.keys)
        var result: Void?
        var error: Error?
        
        viewModel.checkContact(phone: "").subscribe(onNext: {
            result = $0
        }, onError: { error = $0 })
        .disposed(by: disposeBag)
        
        contactStore.completionHandler?(false, nil)
        XCTAssertNotNil(result)
        XCTAssertNil(error)
        XCTAssertNil(contactStore.predicate)
        XCTAssertNil(contactStore.keys)
        XCTAssertFalse(contactStore.isExecute)
        
        // Access & find contact
        result = nil
        contactStore.unifiedContactsResult = [CNContact()]
        
        viewModel.checkContact(phone: "").subscribe(onNext: {
            result = $0
        }, onError: { error = $0 })
        .disposed(by: disposeBag)
        
        contactStore.completionHandler?(true, nil)
        XCTAssertNotNil(result)
        XCTAssertNil(error)
        XCTAssertNotNil(contactStore.predicate)
        XCTAssertNotNil(contactStore.keys)
        XCTAssertFalse(contactStore.isExecute)
        
        // Access, not find, add contact
        result = nil
        contactStore.unifiedContactsResult = []
        contactStore.predicate = nil
        contactStore.keys = nil
        
        viewModel.checkContact(phone: "").subscribe(onNext: {
            result = $0
        }, onError: { error = $0 })
        .disposed(by: disposeBag)
        
        contactStore.completionHandler?(true, nil)
        XCTAssertNotNil(result)
        XCTAssertNil(error)
        XCTAssertNotNil(contactStore.predicate)
        XCTAssertNotNil(contactStore.keys)
        XCTAssertTrue(contactStore.isExecute)
        
        // Access, not find, error when add contact
        result = nil
        contactStore.unifiedContactsResult = []
        contactStore.predicate = nil
        contactStore.keys = nil
        contactStore.isExecute = false
        contactStore.executeError = AppError.unknown
        
        viewModel.checkContact(phone: "").subscribe(onNext: {
            result = $0
        }, onError: { error = $0 })
        .disposed(by: disposeBag)
        
        contactStore.completionHandler?(true, nil)
        XCTAssertNil(result)
        XCTAssertNotNil(error)
        XCTAssertNotNil(contactStore.predicate)
        XCTAssertNotNil(contactStore.keys)
        XCTAssertTrue(contactStore.isExecute)
    }

}
