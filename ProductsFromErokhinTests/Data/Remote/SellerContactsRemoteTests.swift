//
//  SellerContactsRemoteTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class SellerContactsRemoteTests: XCTestCase {
    
    func testManagedObject() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sellerContactsRemote = SellerContactsRemote(phone: "phone", address: "address")
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: context)
        
        let sellerContacts = sellerContactsRemote.managedObject(context: context) as! SellerContacts
        XCTAssertEqual(sellerContacts.phone, sellerContactsRemote.phone)
        XCTAssertEqual(sellerContacts.address, sellerContactsRemote.address)
        
        waitForExpectations(timeout: 1)
    }

}
