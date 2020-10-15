//
//  AboutAppTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 15.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class AboutAppTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func tearDownWithError() throws {
        try AboutApp.clearEntity(context: context)
    }
    
    func testUpdate() {
        let aboutAppRemote = AboutAppRemote(privacy: "privacy", version: "version", appStore: "appStore")
        let order = 1
        
        let aboutApp = AboutApp(context: context)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        aboutApp.update(from: aboutAppRemote, order: order)
        XCTAssertEqual(aboutApp.order, Int16(order))
        XCTAssertEqual(aboutApp.privacy, aboutAppRemote.privacy)
        XCTAssertEqual(aboutApp.version, aboutAppRemote.version)
        XCTAssertEqual(aboutApp.appStore, aboutAppRemote.appStore)
        
        waitForExpectations(timeout: 1)
    }

}
