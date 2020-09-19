//
//  ContextMockTest.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class ContextMockTest: XCTestCase {

    func testContextMock() throws {
        let context = ContextMock()
        // Save
        XCTAssertFalse(context.isSaving)
        try context.save()
        XCTAssertTrue(context.isSaving)
        // Delete, Insert
        XCTAssertFalse(context.isDelete)
        XCTAssertFalse(context.isInsert)
        context.delete(Product(context: context))
        XCTAssertTrue(context.isDelete)
        XCTAssertTrue(context.isInsert)
        // Changes
        XCTAssertTrue(context.hasChanges)
        // Fetch
        var result = try context.fetch(Product.fetchRequest())
        XCTAssertEqual(result.count, context.fetchResult.count)
        context.fetchResult = [Product](repeating: Product(context: context), count: 3)
        result = try context.fetch(Product.fetchRequest())
        XCTAssertEqual(result.count, context.fetchResult.count)
    }

}
