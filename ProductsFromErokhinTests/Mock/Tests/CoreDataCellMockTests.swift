//
//  CoreDataCellMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class CollectionViewCellMockTests: XCTestCase {

    func testBind() {
        let cell = CollectionViewCellMock()
        XCTAssertFalse(cell.isBind)
        cell.bind(model: Product(context: ContextMock()))
        XCTAssertTrue(cell.isBind)
    }

}
