//
//  AboutAppRemoteTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 15.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class AboutAppRemoteTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func tearDownWithError() throws {
        try AboutApp.clearEntity(context: context)
    }
    
    func testManagedObject() {
        let aboutAppRemote = AboutAppRemote(privacy: "privacy", version: "version", appStore: "appStore")
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: context)
        
        let aboutApp = aboutAppRemote.managedObject(context: context, order: 1) as! AboutApp
        XCTAssertEqual(aboutApp.order, 1)
        XCTAssertEqual(aboutApp.privacy, aboutAppRemote.privacy)
        XCTAssertEqual(aboutApp.version, aboutAppRemote.version)
        XCTAssertEqual(aboutApp.appStore, aboutAppRemote.appStore)
        
        waitForExpectations(timeout: 1)
    }

}
