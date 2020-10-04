//
//  OrderWarningTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class OrderWarningTests: XCTestCase {

    func testUpdate() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let orderWarningRemote = OrderWarningRemote(text: "text", groups: ["group"])
        let order = 1
        
        let orderWarning = OrderWarning(context: context)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        orderWarning.update(from: orderWarningRemote, order: order)
        XCTAssertEqual(orderWarning.order, Int16(order))
        XCTAssertEqual(orderWarning.text, orderWarningRemote.text)
        XCTAssertEqual(orderWarning.groups, orderWarningRemote.groups)
        
        waitForExpectations(timeout: 1)
    }

}
