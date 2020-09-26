//
//  ProductCollectionViewCellTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 26.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class ProductCollectionViewCellTests: XCTestCase {
    
    private var cell: ProductCollectionViewCell!
    
    private let _name = UILabel()
    private let price = UILabel()
    private let inCart = UILabel()
    private let inCartMarker = UIView()
    private let _del = UIButton()
    private let img = UIImageView()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cell = ProductCollectionViewCell(frame: .init())
        cell.name = _name
        cell.price = price
        cell.inCart = inCart
        cell.inCartMarker = inCartMarker
        cell._del = _del
        cell.img = img
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBind() {
        let product = Product(context: context)
        product.name = "name"
        product.price = 100
        
        // inCart = 0
        cell.bind(model: product)
        XCTAssertEqual(cell.name.text, product.name)
        XCTAssertTrue(cell.price.text!.contains(String(product.price)))
        XCTAssertEqual(cell.model, product)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
