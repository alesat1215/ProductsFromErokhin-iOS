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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDelivery() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
