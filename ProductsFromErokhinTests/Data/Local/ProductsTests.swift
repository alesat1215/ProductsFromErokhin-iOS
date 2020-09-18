//
//  ProductsTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class ProductsTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // MARK: - Product
    func testProductUpdate() {
        let productRemote = ProductRemote(name: "name", consist: "consist", img: "img", price: 1, inStart: true, inStart2: true)
        let order = 1
        let productsInCart = [ProductInCart(context: context)]
        let product = Product(context: context)
        product.update(from: productRemote, order: order, inCart: productsInCart)
        XCTAssertEqual(product.order, Int16(order))
        XCTAssertEqual(product.name, productRemote.name)
        XCTAssertEqual(product.consist, productRemote.consist)
        XCTAssertEqual(product.img, productRemote.img)
        XCTAssertEqual(product.price, Int16(productRemote.price))
        XCTAssertEqual(product.inStart, productRemote.inStart)
        XCTAssertEqual(product.inStart2, productRemote.inStart2)
        XCTAssertEqual(product.inCart?.anyObject() as? ProductInCart, productsInCart.first)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
