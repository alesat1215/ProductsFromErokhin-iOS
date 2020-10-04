//
//  AppRepositoryTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class AppRepositoryTests: XCTestCase {
    
    private var updater: DatabaseUpdaterMock!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var repository: AppRepository!
    private var products = [Product]()
    private var titles = [Titles]()
    private var groups = [Group]()
    private var orderWarnings = [OrderWarning]()
    private var productsInCart = [ProductInCart]()
    private var sellerContacts = [SellerContacts]()

    override func setUpWithError() throws {
        updater = DatabaseUpdaterMock()
        products = ["product", "product1", "product2"].enumerated().map {
            let product = Product(context: context)
            product.order = Int16($0.offset)
            product.name = $0.element
            return product
        }
        titles = ["title"].map {
            let titles = Titles(context: context)
            titles.title = $0
            return titles
        }
        groups = ["group", "group1", "group2"].enumerated().map {
            let group = Group(context: context)
            group.order = Int16($0.offset)
            group.name = $0.element
            return group
        }
        orderWarnings = ["warning"].enumerated().map {
            let orderWarning = OrderWarning(context: context)
            orderWarning.order = Int16($0.offset)
            orderWarning.text = $0.element
            return orderWarning
        }
        productsInCart = ["product", "product1", "product2"].enumerated().map {
            let productInCart = ProductInCart(context: context)
            productInCart.name = $0.element
            return productInCart
        }
        sellerContacts = ["phone"].enumerated().map {
            let sellerContact = SellerContacts(context: context)
            sellerContact.order = Int16($0.offset)
            sellerContact.phone = $0.element
            return sellerContact
        }
        
        repository = AppRepository(updater: updater, context: context)
    }

    override func tearDownWithError() throws {
        try Product.clearEntity(context: context)
        try Titles.clearEntity(context: context)
        try Group.clearEntity(context: context)
    }
    
    func testGroups() throws {
        // Success
        // Check sequence contains only one element
        var dataSourceCollectionView: Observable<Event<CoreDataSourceCollectionView<Group>>>?
        dataSourceCollectionView = repository.groups(cellId: "")
        XCTAssertThrowsError(try dataSourceCollectionView?.take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        dataSourceCollectionView = repository.groups(cellId: "")
        var result = try dataSourceCollectionView?.toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.collectionView(CollectionViewMock(), numberOfItemsInSection: 0), products.count)
        
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        dataSourceCollectionView = repository.groups(cellId: "")
        let resultArray = try dataSourceCollectionView!.take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.collectionView(CollectionViewMock(), numberOfItemsInSection: 0), products.count)
    }
    
    func testTitles() throws {
        // Success
        // Check sequence contains only one element
        XCTAssertThrowsError(try repository.titles().take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        var result = try repository.titles().toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.count, titles.count)
    
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        let resultArray = try repository.titles().take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.count, titles.count)
    }
    
    func testProductsCollectionView() throws {
        // Success
        // Check sequence contains only one element
        var dataSourceCollectionView: Observable<Event<CoreDataSourceCollectionView<Product>>>?
        dataSourceCollectionView = repository.products(cellId: "")
        XCTAssertThrowsError(try dataSourceCollectionView?.take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        dataSourceCollectionView = repository.products(cellId: "")
        var result = try dataSourceCollectionView?.toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.collectionView(CollectionViewMock(), numberOfItemsInSection: 0), products.count)
        
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        dataSourceCollectionView = repository.products(cellId: "")
        let resultArray = try dataSourceCollectionView!.take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.collectionView(CollectionViewMock(), numberOfItemsInSection: 0), products.count)
    }
    
    func testProductsTableView() throws {
        // Success
        // Check sequence contains only one element
        var dataSourceTableView: Observable<Event<CoreDataSourceTableView<Product>>>?
        dataSourceTableView = repository.products(cellId: "")
        XCTAssertThrowsError(try dataSourceTableView?.take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        dataSourceTableView = repository.products(cellId: "")
        var result = try dataSourceTableView?.toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.tableView(UITableView(frame: .init()), numberOfRowsInSection: 0), products.count)
        
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        dataSourceTableView = repository.products(cellId: "")
        let resultArray = try dataSourceTableView!.take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.tableView(UITableView(frame: .init()), numberOfRowsInSection: 0), products.count)
    }
    
    func testProducts() {
        XCTAssertEqual(try repository.products().take(1).toBlocking().first(), products)
    }
    
    func testOrderWarning() throws {
        // Success
        // Check sequence contains only one element
        XCTAssertThrowsError(try repository.orderWarning().take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        var result = try repository.orderWarning().toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.count, orderWarnings.count)
    
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        let resultArray = try repository.orderWarning().take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.count, orderWarnings.count)
    }
    
    func testClearCart() {
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        
        XCTAssertNoThrow(try repository.clearCart().get())
        
        waitForExpectations(timeout: 1)
    }
    
    func testSellerContacts() throws {
        // Success
        // Check sequence contains only one element
        XCTAssertThrowsError(try repository.sellerContacts().take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        var result = try repository.sellerContacts().toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.count, sellerContacts.count)
    
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        let resultArray = try repository.sellerContacts().take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.count, sellerContacts.count)
    }

}
