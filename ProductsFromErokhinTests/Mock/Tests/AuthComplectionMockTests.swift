//
//  AuthComplectionMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 17.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class AuthComplectionMockTests: XCTestCase {
    
    func testResult() {
        // Success
        let complection = AuthComplectionMock()
        XCTAssertNotNil(try complection.result().toBlocking().first())
        // Error
        complection.error = AppError.unknown
        XCTAssertEqual(try complection.result().toBlocking().first()?.error?.localizedDescription, AppError.unknown.localizedDescription)
    }

}
