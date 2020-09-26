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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let _ = Product(context: context)
        expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: context)
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        try Product.clearEntity(context: context)
        waitForExpectations(timeout: 1)
    }

}
