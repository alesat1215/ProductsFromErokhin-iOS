//
//  UserDefaultsMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class UserDefaultsMockTests: XCTestCase {
    
    private var userDefaults: UserDefaultsMock!

    override func setUpWithError() throws {
        userDefaults = UserDefaultsMock()
    }
    
    func testBool() {
        XCTAssertFalse(userDefaults.isBool)
        XCTAssertEqual(userDefaults.bool(forKey: ""), userDefaults.boolResult)
        XCTAssertTrue(userDefaults.isBool)
    }

}
