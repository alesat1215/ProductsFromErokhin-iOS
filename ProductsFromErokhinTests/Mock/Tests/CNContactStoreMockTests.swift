//
//  CNContactStoreMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import Contacts
@testable import ProductsFromErokhin

class CNContactStoreMockTests: XCTestCase {
    
    private var store: CNContactStoreMock!

    override func setUpWithError() throws {
        store = CNContactStoreMock()
    }

    func testRequestAccess() {
        XCTAssertNil(store.completionHandler)
        store.requestAccess(for: .contacts) { _,_ in }
        XCTAssertNotNil(store.completionHandler)
    }
    
    func testUnifiedContacts() {
        XCTAssertNil(store.predicate)
        XCTAssertNil(store.keys)
        XCTAssertNil(store.unifiedContactsResultThrow)
        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: ""))
        XCTAssertEqual(try store.unifiedContacts(matching: predicate, keysToFetch: []), store.unifiedContactsResult)
        XCTAssertNotNil(store.predicate)
        XCTAssertNotNil(store.keys)
        store.unifiedContactsResultThrow = AppError.unknown
        XCTAssertThrowsError(try store.unifiedContacts(matching: predicate, keysToFetch: []))
    }

}
