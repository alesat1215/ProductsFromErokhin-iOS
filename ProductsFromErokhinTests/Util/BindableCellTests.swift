//
//  CoreDataCellTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class BindableCellTests: XCTestCase {
        
    func testBindCollectionViewCell() throws {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let model = Product(context: context)
        let cell = BindableCollectionViewCell<Product>()
        cell.bind(model: model)
        XCTAssertEqual(cell.model, model)
    }

}
