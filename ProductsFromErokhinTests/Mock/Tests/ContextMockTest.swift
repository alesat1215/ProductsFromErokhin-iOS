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
        // Insert
        XCTAssertFalse(context.isInsert)
        context.insert(Product(context: context))
        XCTAssertTrue(context.isInsert)
        
        XCTAssertTrue(context.hasChanges)
    }

}
