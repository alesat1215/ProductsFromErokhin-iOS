//
//  ProfileTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class ProfileTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func tearDownWithError() throws {
        try Profile.clearEntity(context: context)
    }
    
    func testDelivery() {
        
        let profile = Profile(context: context)
        
        // Profile with nil fields
        XCTAssertTrue(profile.delivery().isEmpty)
        
        // Profile with empty fields
        profile.name = nil
        profile.phone = nil
        profile.address = nil
        XCTAssertTrue(profile.delivery().isEmpty)
        profile.name = ""
        profile.phone = ""
        profile.address = ""
        XCTAssertTrue(profile.delivery().isEmpty)
        
        // Only name
        profile.name = "name"
        profile.phone = nil
        profile.address = nil
        XCTAssertEqual(profile.delivery(), "\r\n\r\nname")
        
        // Only phone
        profile.name = nil
        profile.phone = "phone"
        profile.address = nil
        XCTAssertEqual(profile.delivery(), "\r\n\r\nphone")
        
        // Only address
        profile.name = nil
        profile.phone = nil
        profile.address = "address"
        XCTAssertEqual(profile.delivery(), "\r\n\r\naddress")
        
        // Name, phone
        profile.name = "name"
        profile.phone = "phone"
        profile.address = nil
        XCTAssertEqual(profile.delivery(), "\r\n\r\nname\r\nphone")
        
        // Name, address
        profile.name = "name"
        profile.phone = nil
        profile.address = "address"
        XCTAssertEqual(profile.delivery(), "\r\n\r\nname\r\naddress")
        
        // Phone, address
        profile.name = nil
        profile.phone = "phone"
        profile.address = "address"
        XCTAssertEqual(profile.delivery(), "\r\n\r\nphone\r\naddress")
        
        // Name, phone, address
        profile.name = "name"
        profile.phone = "phone"
        profile.address = "address"
        XCTAssertEqual(profile.delivery(), "\r\n\r\nname\r\nphone\r\naddress")
    }

}
