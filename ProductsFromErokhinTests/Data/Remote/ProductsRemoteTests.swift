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
        
        XCTAssertEqual(productOrder, productsRemote.count)
        XCTAssertEqual(group.name, groupRemote.name)
        XCTAssertEqual(group.products?.count, productsRemote.count)
        let product = group.products?.filter { ($0 as! Product).name == "product" }.first as! Product
        XCTAssertEqual(product.inCart?.count, 0)
        let product2 = group.products?.filter { ($0 as! Product).name == "product2" }.first as! Product
        XCTAssertEqual(product2.inCart?.count, allInCart.count)
        let product3 = group.products?.filter { ($0 as! Product).name == "product3" }.first as! Product
        XCTAssertEqual(product3.inCart?.count, 0)
    }

}
