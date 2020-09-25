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
    private var context: ContextMock!
    private var repository: AppRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        updater = DatabaseUpdaterMock()
        context = ContextMock()
        repository = AppRepository(updater: updater, context: context)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testProducts() throws {
        // Products for CollectionView
        // Success
        // Check sequence contains only one element
        var dataSourceCollectionView: Observable<Event<CoreDataSourceCollectionView<Product>>>?
        dataSourceCollectionView = repository.products(cellId: "")
        XCTAssertThrowsError(try dataSourceCollectionView?.take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        context.isFetch = false
        // Check that element
        dataSourceCollectionView = repository.products(cellId: "")
        XCTAssertNotNil(try dataSourceCollectionView?.toBlocking().first()?.element)
        XCTAssertTrue(updater.isSync)
        XCTAssertTrue(context.isFetch)
        
        // Sync error
        updater.isSync = false
        context.isFetch = false
        updater.error = AppError.unknown
        dataSourceCollectionView = repository.products(cellId: "")
        XCTAssertTrue(try dataSourceCollectionView!.take(2).toBlocking().toArray().contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        XCTAssertTrue(context.isFetch)
    }
    
    func testTitles() {
        // Success
        // Check sequence contains only one element
        XCTAssertThrowsError(try repository.titles().take(2).toBlocking(timeout: 1).toArray())
        updater.isSync = false
        context.isFetch = false
        // Check that element
        XCTAssertNotNil(try repository.titles().toBlocking().first()?.element)
        XCTAssertTrue(updater.isSync)
        XCTAssertTrue(context.isFetch)
        
        // Sync error
        updater.isSync = false
        context.isFetch = false
        updater.error = AppError.unknown
        XCTAssertTrue(try repository.titles().take(2).toBlocking().toArray().contains { $0.error?.localizedDescription == AppError.unknown.localizedDescription })
        XCTAssertTrue(updater.isSync)
        XCTAssertTrue(context.isFetch)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
