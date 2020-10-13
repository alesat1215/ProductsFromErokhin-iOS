//
//  SellerContactsTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class SellerContactsTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func tearDownWithError() throws {
        try SellerContacts.clearEntity(context: context)
    }

    func testUpdate() {
        let sellerContactsRemote = SellerContactsRemote(phone: "phone", address: "address")
        let order = 1
        
        let sellerContacts = SellerContacts(context: context)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        sellerContacts.update(from: sellerContactsRemote, order: order)
        XCTAssertEqual(sellerContacts.order, Int16(order))
        XCTAssertEqual(sellerContacts.phone, sellerContactsRemote.phone)
        XCTAssertEqual(sellerContacts.address, sellerContactsRemote.address)
        
        waitForExpectations(timeout: 1)
    }

}
