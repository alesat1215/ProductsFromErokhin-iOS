//
//  RepositoryTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import CoreData
@testable import ProductsFromErokhin

class RepositoryTests: XCTestCase {
    
    private var updater: DatabaseUpdaterMock!
    private var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private var repository: Repository!
    private var products = [Product]()
    private var titles = [Titles]()
    private var groups = [Group]()
    private var orderWarnings = [OrderWarning]()
    private var productsInCart = [ProductInCart]()
    private var sellerContacts = [SellerContacts]()
    private var profile = [Profile]()
    private var instructions = [Instruction]()
    private var aboutProducts = [AboutProducts]()
    private var aboutApp = [AboutApp]()

    override func setUpWithError() throws {
        updater = DatabaseUpdaterMock()
        products = ["product", "product1", "product2"].enumerated().map {
            let product = Product(context: container.viewContext)
            product.order = Int16($0.offset)
            product.name = $0.element
            return product
        }
        titles = ["title"].map {
            let titles = Titles(context: container.viewContext)
            titles.title = $0
            return titles
        }
        groups = ["group", "group1", "group2"].enumerated().map {
            let group = Group(context: container.viewContext)
            group.order = Int16($0.offset)
            group.name = $0.element
            return group
        }
        orderWarnings = ["warning"].enumerated().map {
            let orderWarning = OrderWarning(context: container.viewContext)
            orderWarning.order = Int16($0.offset)
            orderWarning.text = $0.element
            return orderWarning
        }
        productsInCart = ["product", "product1", "product2"].enumerated().map {
            let productInCart = ProductInCart(context: container.viewContext)
            productInCart.name = $0.element
            return productInCart
        }
        sellerContacts = ["phone"].enumerated().map {
            let sellerContact = SellerContacts(context: container.viewContext)
            sellerContact.order = Int16($0.offset)
            sellerContact.phone = $0.element
            return sellerContact
        }
        profile = ["name"].enumerated().map {
            let profile = Profile(context: container.viewContext)
            profile.order = Int16($0.offset)
            profile.name = $0.element
            return profile
        }
        instructions = ["title", "title1", "title2"].enumerated().map {
            let instruction = Instruction(context: container.viewContext)
            instruction.order = Int16($0.offset)
            instruction.title = $0.element
            return instruction
        }
        aboutProducts = ["text", "text1", "text2"].enumerated().map {
            let about = AboutProducts(context: container.viewContext)
            about.order = Int16($0.offset)
            about.text = $0.element
            about.section = Int16($0.offset % 2)
            return about
        }
        aboutApp = ["appStore"].enumerated().map {
            let aboutApp = AboutApp(context: container.viewContext)
            aboutApp.order = Int16($0.offset)
            aboutApp.appStore = $0.element
            return aboutApp
        }
        
        try container.viewContext.save()
        
        repository = RepositoryImpl(updater: updater, container: container)
    }

    override func tearDownWithError() throws {
        try Product.clearEntity(context: container.viewContext)
        try Titles.clearEntity(context: container.viewContext)
        try Group.clearEntity(context: container.viewContext)
        try OrderWarning.clearEntity(context: container.viewContext)
        try ProductInCart.clearEntity(context: container.viewContext)
        try SellerContacts.clearEntity(context: container.viewContext)
        try Profile.clearEntity(context: container.viewContext)
        try Instruction.clearEntity(context: container.viewContext)
        try AboutProducts.clearEntity(context: container.viewContext)
    }
    
    func testLoadData() throws {
        // Success
        // Check sequence is empty
        XCTAssertNil(try repository.loadData().toBlocking().first())
        updater.isSync = false
        
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        let result: Event<Void>? = try repository.loadData().toBlocking().first()
        XCTAssertEqual(result?.error?.localizedDescription, AppError.unknown.localizedDescription)
        XCTAssertTrue(updater.isSync)
    }
    
    func testGroups() throws {
        // Success
        // Check sequence contains only one element
        var dataSourceCollectionView: Observable<Event<CoreDataSourceCollectionView<Group>>>?
        dataSourceCollectionView = repository.groups(cellId: [])
        XCTAssertThrowsError(try dataSourceCollectionView?.take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        dataSourceCollectionView = repository.groups(cellId: [])
        var result = try dataSourceCollectionView?.toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.collectionView(CollectionViewMock(), numberOfItemsInSection: 0), products.count)
        
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        dataSourceCollectionView = repository.groups(cellId: [])
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
        dataSourceCollectionView = repository.products(predicate: nil, cellId: [])
        XCTAssertThrowsError(try dataSourceCollectionView?.take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        dataSourceCollectionView = repository.products(predicate: nil, cellId: [])
        var result = try dataSourceCollectionView?.toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.collectionView(CollectionViewMock(), numberOfItemsInSection: 0), products.count)
        
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        dataSourceCollectionView = repository.products(predicate: nil, cellId: [])
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
        dataSourceTableView = repository.products(predicate: nil, cellId: "")
        XCTAssertThrowsError(try dataSourceTableView?.take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        dataSourceTableView = repository.products(predicate: nil, cellId: "")
        var result = try dataSourceTableView?.toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.tableView(UITableView(frame: .init()), numberOfRowsInSection: 0), products.count)
        
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        dataSourceTableView = repository.products(predicate: nil, cellId: "")
        let resultArray = try dataSourceTableView!.take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.tableView(UITableView(frame: .init()), numberOfRowsInSection: 0), products.count)
    }
    
    func testProducts() {
        XCTAssertEqual(try repository.products(predicate: nil).take(1).toBlocking().first(), products)
    }
    
    func testOrderWarning() throws {
        // Success
        // Check sequence contains only one element
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
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
        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil)
        
        XCTAssertNoThrow(try repository.clearCart().toBlocking().first())
        
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
    
    func testProfile() {
        XCTAssertEqual(try repository.profile().toBlocking().first(), profile)
    }
    
    func testUpdateProfile() throws {
        var profiles = try repository.profile().toBlocking().first()!
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles.first?.name, "name")
        XCTAssertNil(profiles.first?.phone)
        XCTAssertNil(profiles.first?.address)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: nil)
        
        XCTAssertNoThrow(try repository.updateProfile(name: "name2", phone: "phone", address: "address").toBlocking().first())
        profiles = try repository.profile().toBlocking().first()!
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles.first?.name, "name2")
        XCTAssertEqual(profiles.first?.phone, "phone")
        XCTAssertEqual(profiles.first?.address, "address")
        
        waitForExpectations(timeout: 1)
    }
    
    func testInstructions() throws {
        // Success
        // Check sequence contains only one element
        XCTAssertThrowsError(try repository.instructions().take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        var result = try repository.instructions().toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.count, instructions.count)
    
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        let resultArray = try repository.instructions().take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.count, instructions.count)
    }
    
    func testAboutProducts() throws {
        // Success
        // Check sequence contains only one element
        var dataSourceCollectionView: Observable<Event<CoreDataSourceCollectionView<AboutProducts>>>?
        dataSourceCollectionView = repository.aboutProducts(cellId: [])
        XCTAssertThrowsError(try dataSourceCollectionView?.take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        dataSourceCollectionView = repository.aboutProducts(cellId: [])
        var result = try dataSourceCollectionView?.toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.collectionView(CollectionViewMock(), numberOfItemsInSection: 0), aboutProducts.filter { $0.section == 0 }.count)
        
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        dataSourceCollectionView = repository.aboutProducts(cellId: [])
        let resultArray = try dataSourceCollectionView!.take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.collectionView(CollectionViewMock(), numberOfItemsInSection: 0), aboutProducts.filter { $0.section == 0 }.count)
    }
    
    func testAboutApp() throws {
        // Success
        // Check sequence contains only one element
        XCTAssertThrowsError(try repository.aboutApp().take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        // Check that element
        var result = try repository.aboutApp().toBlocking().first()?.element
        XCTAssertTrue(updater.isSync)
        XCTAssertEqual(result?.count, aboutApp.count)
    
        // Sync error
        updater.isSync = false
        updater.error = AppError.unknown
        let resultArray = try repository.aboutApp().take(2).toBlocking().toArray()
        XCTAssertTrue(resultArray.contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        result = resultArray.first { $0.error == nil }?.element
        XCTAssertEqual(result?.count, aboutApp.count)
    }

}
