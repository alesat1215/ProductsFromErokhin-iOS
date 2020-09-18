//
//  OrderedTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class OrderedTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFetchRequestWithSort() {
        var fetchRequest = Product.fetchRequestWithSort()
        XCTAssertEqual(fetchRequest.sortDescriptors?.first?.key, "order")
        XCTAssertTrue(fetchRequest.sortDescriptors?.first?.ascending ?? false)
        XCTAssertNil(fetchRequest.predicate)
        let predicate = NSPredicate()
        fetchRequest = Product.fetchRequestWithSort(predicate: predicate)
        XCTAssertEqual(fetchRequest.sortDescriptors?.first?.key, "order")
        XCTAssertTrue(fetchRequest.sortDescriptors?.first?.ascending ?? false)
        XCTAssertEqual(fetchRequest.predicate, predicate)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
