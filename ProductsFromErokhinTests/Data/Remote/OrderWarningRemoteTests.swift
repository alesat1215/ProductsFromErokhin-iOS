//
//  OrderWarningRemoteTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class OrderWarningRemoteTests: XCTestCase {
    
    func testManagedObject() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let orderWarningRemote = OrderWarningRemote(text: "text", groups: ["group"])
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: context)
        
        let orderWarning = orderWarningRemote.managedObject(context: context) as! OrderWarning
        XCTAssertEqual(orderWarning.text, orderWarningRemote.text)
        XCTAssertEqual(orderWarning.groups, orderWarningRemote.groups)
        
        waitForExpectations(timeout: 1)
    }

}
