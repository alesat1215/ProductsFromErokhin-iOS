//
//  TableViewCellMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 28.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class TableViewCellMockTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func testBind() {
        let cell = TableViewCellMock()
        XCTAssertFalse(cell.isBind)
        cell.bind(model: Product(context: context))
        XCTAssertTrue(cell.isBind)
    }

}
