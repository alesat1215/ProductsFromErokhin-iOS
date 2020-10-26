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
        cell = ProductCollectionViewCell(frame: .init())
        cell.name = _name
        cell.price = price
        cell.inCart = inCart
        cell.inCartMarker = inCartMarker
        cell._del = _del
        cell.img = img
    }

    override func tearDownWithError() throws {
        try Product.clearEntity(context: context)
    }
    
    func testAdd() {
        let product = Product(context: context)
        product.name = "name"
        XCTAssertEqual(product.inCart?.count, 0)
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        XCTAssertNoThrow(try product.addToCart().get())
        XCTAssertEqual(product.inCart?.count, 1)
        waitForExpectations(timeout: 1)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        XCTAssertNoThrow(try product.addToCart().get())
        XCTAssertEqual(product.inCart?.count, 2)
        waitForExpectations(timeout: 1)
    }
    
    func testDel() {
        let product = Product(context: context)
        product.name = "name"
        _ = product.addToCart()
        _ = product.addToCart()
        XCTAssertEqual(product.inCart?.count, 2)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        XCTAssertNoThrow(try product.delFromCart().get())
        XCTAssertEqual(product.inCart?.count, 1)
        waitForExpectations(timeout: 1)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        XCTAssertNoThrow(try product.delFromCart().get())
        XCTAssertEqual(product.inCart?.count, 0)
        waitForExpectations(timeout: 1)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        XCTAssertNoThrow(try product.delFromCart().get())
        XCTAssertEqual(product.inCart?.count, 0)
        waitForExpectations(timeout: 1)
    }
    
    func testBind() {
        let product = Product(context: context)
        product.name = "name"
        product.price = 100
        
        // inCart == 0
        cell.bind(model: product)
        XCTAssertEqual(cell.name.text, product.name)
        XCTAssertTrue(cell.price.text!.contains(String(product.price)))
        XCTAssertEqual(cell.model, product)
        XCTAssertEqual(cell.inCart.text, String(product.inCart?.count ?? 0))
        XCTAssertEqual(cell.inCartMarker.alpha, 0)
        XCTAssertTrue(cell._del.isHidden)
        XCTAssertTrue(cell.inCart.isHidden)
        // inCart != 0
        _ = product.addToCart()
        cell.bind(model: product)
        XCTAssertEqual(cell.name.text, product.name)
        XCTAssertTrue(cell.price.text!.contains(String(product.price)))
        XCTAssertEqual(cell.model, product)
        XCTAssertEqual(cell.inCart.text, String(product.inCart?.count ?? 0))
        XCTAssertEqual(cell.inCartMarker.alpha, 1)
        XCTAssertFalse(cell._del.isHidden)
        XCTAssertFalse(cell.inCart.isHidden)
    }

}
