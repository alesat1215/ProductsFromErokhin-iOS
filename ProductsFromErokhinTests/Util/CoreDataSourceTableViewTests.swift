//
//  CoreDataSourceTableViewTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 26.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class CoreDataSourceTableViewTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var groups = [Group]()
    private var products = [Product]()
    private var dataSourceProducts: CoreDataSourceTableView<Product>!
    private var tableView: TableViewMock!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Add products to context
        groups = ["group", "group1", "group2"].enumerated().map {
            let group = Group(context: context)
            group.order = Int16($0.offset)
            group.name = $0.element
            return group
        }
        
        products = ["product", "product1", "product2"].enumerated().map {
            let product = Product(context: context)
            product.order = Int16($0.offset)
            product.name = $0.element
            product.group = groups[$0.offset]
            return product
        }
        
        dataSourceProducts = try context.rx.coreDataSource(cellId: "product", fetchRequest: Product.fetchRequestWithSort()).toBlocking().first()
        tableView = TableViewMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try Product.clearEntity(context: context)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCoreDataSource() throws {
        XCTAssertNotNil(dataSourceProducts)
    }
    
    func testBind() {
        XCTAssertNil(tableView.dataSource)
        XCTAssertFalse(tableView.isReload)
        dataSourceProducts.bind(tableView: tableView)
        XCTAssertNotNil(tableView.dataSource)
        XCTAssertTrue(tableView.isReload)
    }
    
    func testUITableViewDataSource() {
        // Count of items
        XCTAssertEqual(dataSourceProducts.tableView(tableView, numberOfRowsInSection: 0), products.count)
        // Cell for indexPath
        let cell = dataSourceProducts.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue((cell as! TableViewCellMock).isBind)
    }
    
    func testNSFetchedResultsControllerDelegate() {
        let fetchRequest = Product.fetchRequestWithSort() as! NSFetchRequest<NSFetchRequestResult>
        let frc: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Not bind
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: nil)
        XCTAssertFalse(tableView.isInsert)
        // Bind
        dataSourceProducts.bind(tableView: tableView)
        // Insert
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: nil)
        XCTAssertFalse(tableView.isInsert)
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: .init())
        XCTAssertTrue(tableView.isInsert)
        tableView.isInsert.toggle()
        // Update
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .update, newIndexPath: nil)
        XCTAssertFalse(tableView.cell.isBind)
        dataSourceProducts.controller(frc, didChange: products.first!, at: .init(), for: .update, newIndexPath: nil)
        XCTAssertTrue(tableView.cell.isBind)
        tableView.cell.isBind.toggle()
        // Move
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .move, newIndexPath: nil)
        XCTAssertFalse(tableView.isInsert)
        XCTAssertFalse(tableView.isDelete)
        dataSourceProducts.controller(frc, didChange: products.first!, at: .init(), for: .move, newIndexPath: .init())
        XCTAssertTrue(tableView.isInsert)
        XCTAssertTrue(tableView.isDelete)
        tableView.isInsert.toggle()
        tableView.isDelete.toggle()
        // Delete
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .delete, newIndexPath: nil)
//        XCTAssertFalse(tableView.isDelete)
        tableView.isReload = false
        dataSourceProducts.controller(frc, didChange: products.first!, at: IndexPath(item: 0, section: 0), for: .delete, newIndexPath: nil)
//        XCTAssertTrue(tableView.isDelete)
//        tableView.isDelete.toggle()
        XCTAssertTrue(tableView.isReload)
        tableView.isReload.toggle()
    }
    
    func testProductPositionForGroup() {
        // Product found
        XCTAssertEqual(dataSourceProducts.productPositionForGroup(group: groups.first!)?.row, 0)
        XCTAssertEqual(dataSourceProducts.productPositionForGroup(group: groups[1])?.row, 1)
        XCTAssertEqual(dataSourceProducts.productPositionForGroup(group: groups[2])?.row, 2)
        // Product not found
        XCTAssertNil(dataSourceProducts.productPositionForGroup(group: Group(context: context)))
    }
    
    func testObject() {
        XCTAssertEqual(dataSourceProducts.object(at: IndexPath(item: 0, section: 0)), products.first!)
        XCTAssertNil(dataSourceProducts.object(at: IndexPath(item: 0, section: 7)))
        XCTAssertNil(dataSourceProducts.object(at: IndexPath(item: 5, section: 0)))
    }
    
    func testDispose() {
        dataSourceProducts.bind(tableView: tableView)
        XCTAssertNotNil(tableView.dataSource)
        dataSourceProducts.dispose()
        XCTAssertNil(tableView.dataSource)
    }

}
