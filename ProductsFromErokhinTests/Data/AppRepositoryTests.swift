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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        updater = DatabaseUpdaterMock()
//        context = ContextMock()
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
        repository = AppRepository(updater: updater, context: context)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try Product.clearEntity(context: context)
        try Titles.clearEntity(context: context)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
    


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
