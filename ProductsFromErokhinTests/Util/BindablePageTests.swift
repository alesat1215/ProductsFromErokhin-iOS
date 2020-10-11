//
//  BindablePageTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class BindablePageTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func tearDownWithError() throws {
        try Product.clearEntity(context: context)
    }
    
    func testBind() {
        let model = Product(context: context)
        let page = BindablePage<Product>()
        page.bind(model: model)
        XCTAssertEqual(page.model, model)
    }

}
