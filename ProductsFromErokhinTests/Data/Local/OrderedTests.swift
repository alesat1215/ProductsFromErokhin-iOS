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
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        // Clear products
        try Product.clearEntity(context: context)
        try context.save()
        // Add products
        let products: [NSManagedObject] = [("product", 0), ("product2", 1), ("product3", 2)].map {
            let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
            product.setValue($0.0, forKey: "name")
            product.setValue($0.1, forKey: "order")
            return product
        }
        // Del products
        XCTAssertEqual(context.deletedObjects.count, 0)
        try Product.clearEntity(context: context)
        XCTAssertEqual(context.deletedObjects.count, products.count)
        try context.save()
    }

}
