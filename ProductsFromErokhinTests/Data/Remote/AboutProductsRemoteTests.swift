//
//  AboutProductsRemoteTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 13.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class AboutProductsRemoteTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func tearDownWithError() throws {
        try AboutProducts.clearEntity(context: context)
    }
    
    func testManagedObject() {
        let aboutProductsRemote = AboutProductsRemote(title: "title", text: "text", img: "img")
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: context)
        
        let aboutProducts = aboutProductsRemote.managedObject(context: context, order: 1) as! AboutProducts
        XCTAssertEqual(aboutProducts.order, 1)
        XCTAssertEqual(aboutProducts.title, aboutProductsRemote.title)
        XCTAssertEqual(aboutProducts.text, aboutProductsRemote.text)
        XCTAssertEqual(aboutProducts.img, aboutProductsRemote.img)
        XCTAssertEqual(aboutProducts.section, 1)
        
        waitForExpectations(timeout: 1)
    }

}
