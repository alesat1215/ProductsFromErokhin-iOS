//
//  OrderedTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class OrderedTests: XCTestCase {
    
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
    
    func testClearEntity() throws {
        let context = ContextMock()
        context.fetchResult = [Product](repeating: Product(context: context), count: 3)
        XCTAssertFalse(context.isDelete)
        try Product.clearEntity(context: context)
        XCTAssertTrue(context.isDelete)
    }

}
