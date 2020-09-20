//
//  AppRepositoryMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class AppRepositoryMockTests: XCTestCase {
    
    private let repository = AppRepositoryMock()

    func testTitles() {
        XCTAssertEqual(try repository.titles().toBlocking().first()?.element, repository.titlesResult)
    }
    
    func testProducts() {
        let cellId = "cellId"
        let predicate = NSPredicate()
        XCTAssertEqual(try repository.products(predicate: predicate, cellId: cellId).toBlocking().first()?.element, repository.productsResult)
        XCTAssertEqual(repository.cellId, cellId)
        XCTAssertEqual(repository.predicate, predicate)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
