//
//  AuthMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 06.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class AuthMockTests: XCTestCase {
    
    func testSignInAnonymously() {
        let auth = AuthMock()
        XCTAssertNil(auth.completion)
        auth.signInAnonymously(completion: {_,_ in })
        XCTAssertNotNil(auth.completion)
    }

}
