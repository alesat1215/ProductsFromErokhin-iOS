//
//  ProductsRemoteTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class ProductsRemoteTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testManagedObject() {
        let allInCart: [ProductInCart] = ["product2", "product2", "product2"].map {
            let product = ProductInCart(context: context)
            product.setValue($0, forKey: "name")
            return product
        }
        let productsRemote = [
            ProductRemote(name: "product", consist: "", img: "", price: 0, inStart: false, inStart2: false),
            ProductRemote(name: "product2", consist: "", img: "", price: 0, inStart: false, inStart2: false),
            ProductRemote(name: "product3", consist: "", img: "", price: 0, inStart: false, inStart2: false)
        ]
        let groupRemote = GroupRemote(name: "group", products: productsRemote)
        var productOrder = 0
        let group = groupRemote.managedObject(context: context, groupOrder: 0, productOrder: &productOrder, allInCart: allInCart) as! Group
        XCTAssertEqual(group.name, groupRemote.name)
        XCTAssertEqual(group.products?.count, productsRemote.count)
        XCTAssertEqual(productOrder, productsRemote.count)
        
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
