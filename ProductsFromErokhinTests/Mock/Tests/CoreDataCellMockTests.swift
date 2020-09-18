//
//  CoreDataCellMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class CoreDataCellMockTests: XCTestCase {

    func testBind() {
        let cell = CoreDataCellMock()
        XCTAssertFalse(cell.isBind)
        cell.bind(model: Product(context: ContextMock()), indexPath: IndexPath(), dataSource: nil)
        XCTAssertTrue(cell.isBind)
    }

}
