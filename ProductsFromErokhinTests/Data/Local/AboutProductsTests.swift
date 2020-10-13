//
//  AboutProductsTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 13.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class AboutProductsTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func tearDownWithError() throws {
        try AboutProducts.clearEntity(context: context)
    }
    
    func testUpdate() {
        var aboutProductsRemote = AboutProductsRemote(title: "title", text: "text", img: "")
        let order = 1
        
        let aboutProducts = AboutProducts(context: context)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        // Section 0
        aboutProducts.update(from: aboutProductsRemote, order: order)
        XCTAssertEqual(aboutProducts.order, Int16(order))
        XCTAssertEqual(aboutProducts.title, aboutProductsRemote.title)
        XCTAssertEqual(aboutProducts.text, aboutProductsRemote.text)
        XCTAssertEqual(aboutProducts.img, aboutProductsRemote.img)
        XCTAssertEqual(aboutProducts.section, 0)
        // Section 1
        aboutProductsRemote = AboutProductsRemote(title: "title", text: "text", img: "img")
        aboutProducts.update(from: aboutProductsRemote, order: order)
        XCTAssertEqual(aboutProducts.order, Int16(order))
        XCTAssertEqual(aboutProducts.title, aboutProductsRemote.title)
        XCTAssertEqual(aboutProducts.text, aboutProductsRemote.text)
        XCTAssertEqual(aboutProducts.img, aboutProductsRemote.img)
        XCTAssertEqual(aboutProducts.section, 1)
        
        waitForExpectations(timeout: 1)
    }

}
