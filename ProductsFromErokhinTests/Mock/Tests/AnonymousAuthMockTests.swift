//
//  AnonymousAuthMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 21.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class AnonymousAuthMockTests: XCTestCase {
    
    func testSignIn() {
        let auth = AnonymousAuthMock()
        XCTAssertNotNil(try auth.signIn().toBlocking().first()?.element)
    }

}
