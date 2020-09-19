//
//  CoreDataCellTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class CoreDataCellTests: XCTestCase {
        
    func testBind() throws {
        let context = ContextMock()
        let dataSource = try context.rx.coreDataSource(cellId: "product", fetchRequest: Product.fetchRequestWithSort()).toBlocking().first()
        let indexPath = IndexPath()
        let cell = CoreDataCell<Product>()
        cell.bind(model: Product(context: context), indexPath: .init(), dataSource: dataSource)
        XCTAssertEqual(cell.indexPath, indexPath)
        XCTAssertEqual(cell.dataSource, dataSource)
    }

}
