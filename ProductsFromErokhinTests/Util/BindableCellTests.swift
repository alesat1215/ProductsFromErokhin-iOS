//
//  CoreDataCellTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class BindableCellTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func tearDownWithError() throws {
        try Product.clearEntity(context: context)
    }
    
    func testBindableTableViewCell() {
        let model = Product(context: context)
        let cell = BindableTableViewCell<Product>()
        cell.bind(model: model)
        XCTAssertEqual(cell.model, model)
    }
        
    func testBindCollectionViewCell() throws {
        let model = Product(context: context)
        let cell = BindableCollectionViewCell<Product>()
        cell.bind(model: model)
        XCTAssertEqual(cell.model, model)
    }

}
