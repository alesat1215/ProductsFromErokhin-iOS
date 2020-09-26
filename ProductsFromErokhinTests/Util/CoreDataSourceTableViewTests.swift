//
//  CoreDataSourceTableViewTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 26.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class CoreDataSourceTableViewTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var products = [Product]()
    private var dataSourceProducts: CoreDataSourceTableView<Product>!
    private var tableView: TableViewMock!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Add products to context
        products = ["product", "product1", "product2"].enumerated().map {
            let product = Product(context: context)
            product.order = Int16($0.offset)
            product.name = $0.element
            return product
        }
        
        dataSourceProducts = try context.rx.coreDataSource(cellId: "", fetchRequest: Product.fetchRequestWithSort()).toBlocking().first()
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
