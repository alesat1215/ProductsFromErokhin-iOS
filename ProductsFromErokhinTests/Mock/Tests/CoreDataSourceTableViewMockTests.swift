//
//  CoreDataSourceTableViewMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 28.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class CoreDataSourceTableViewMockTests: XCTestCase {
    
    private var dataSource: CoreDataSourceTableViewMock<Product>!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func setUpWithError() throws {
        dataSource = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
    }

    override func tearDownWithError() throws {
        try Product.clearEntity(context: context)
        try Group.clearEntity(context: context)
    }
    
    func testProductPositionForGroup() {
        dataSource.indexPathResult = IndexPath()
        XCTAssertEqual(dataSource.productPositionForGroup(group: Group(context: context)), dataSource.indexPathResult)
    }
    
    func testObject() {
        dataSource.objectResult = Product(context: context)
        XCTAssertEqual(dataSource.object(at: IndexPath()), dataSource.objectResult)
    }

}
