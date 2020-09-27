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
        try Group.clearEntity(context: context)
        try ProductInCart.clearEntity(context: context)
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
    
    // MARK: - ProductInCart
    func testFetchRequestWithSortByName() {
        let fetchRequest = ProductInCart.fetchRequestWithSortByName()
        XCTAssertEqual(fetchRequest.sortDescriptors?.first?.key, "name")
        XCTAssertEqual(fetchRequest.sortDescriptors?.first?.ascending, true)
    }
    
    func testClearEntity() throws {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let _ = ProductInCart(context: context)
        expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: context)
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        try ProductInCart.clearEntity(context: context)
        waitForExpectations(timeout: 1)
    }
    
    // MARK: - Group
    func testGroupUpdate() {
        let groupRemote = GroupRemote(name: "name", products: [])
        let order = 1
        let group = Group(context: context)
        group.update(from: groupRemote, order: order)
        XCTAssertEqual(group.order, Int16(order))
        XCTAssertEqual(group.name, groupRemote.name)
    }
    
    func testSelect() {
        let group = Group(context: context)
        XCTAssertFalse(group.isSelected)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        
        XCTAssertNoThrow(try group.select().get())
        XCTAssertTrue(group.isSelected)
        
        waitForExpectations(timeout: 1)
    }
    
    func testUnSelect() {
        let group = Group(context: context)
        group.isSelected = true
        XCTAssertTrue(group.isSelected)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        group.unSelect()
        XCTAssertFalse(group.isSelected)
        
        waitForExpectations(timeout: 1)
    }
    
    func testSave() throws {
        var contextFromBlock: NSManagedObjectContext?
        
        // Context error
        var product = Product(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        switch product.save({ contextFromBlock = $0 }) {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, AppError.context.localizedDescription)
        default:
            XCTFail("Must be failure")
        }
        XCTAssertNil(contextFromBlock)
        
        waitForExpectations(timeout: 1)
        
        // Succes when already save
        product = Product(context: context)
        product.order = 1
        try context.save()
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        XCTAssertNoThrow(try product.save({ contextFromBlock = $0 }).get())
        XCTAssertEqual(contextFromBlock, context)
        
        waitForExpectations(timeout: 1)
        
        // Success with saving
        contextFromBlock = nil
        product = Product(context: context)
        product.order = 2
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        
        XCTAssertNoThrow(try product.save({ contextFromBlock = $0 }).get())
        XCTAssertEqual(contextFromBlock, context)
        
        waitForExpectations(timeout: 1)
    }

}
