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
        try Product.clearEntity(context: context)
        try context.save()
    }

    override func tearDownWithError() throws {
        try Product.clearEntity(context: context)
        try context.save()
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
    
    func testAddToCart() {
        let product = Product(context: context)
        product.name = "name"
        XCTAssertEqual(product.inCart?.count, 0)
        let result = product.addToCart()
        XCTAssertNoThrow(try result.get())
        XCTAssertEqual((product.inCart?.anyObject() as! ProductInCart).name, product.name)
    }
    
    func testDelFromCart() {
        let product = Product(context: context)
        product.name = "name"
        _ = product.addToCart()
        XCTAssertEqual(product.inCart?.count, 1)
        let result = product.delFromCart()
        XCTAssertNoThrow(try result.get())
        XCTAssertEqual(product.inCart?.count, 0)
    }
    
    func testFetchRequestWithSortByName() {
        let fetchRequest = ProductInCart.fetchRequestWithSortByName()
        XCTAssertEqual(fetchRequest.sortDescriptors?.first?.key, "name")
        XCTAssertEqual(fetchRequest.sortDescriptors?.first?.ascending, true)
    }
    
    func testGroupUpdate() {
        let groupRemote = GroupRemote(name: "name", products: [])
        let order = 1
        let group = Group(context: context)
        group.update(from: groupRemote, order: order)
        XCTAssertEqual(group.order, Int16(order))
        XCTAssertEqual(group.name, groupRemote.name)
    }

}
