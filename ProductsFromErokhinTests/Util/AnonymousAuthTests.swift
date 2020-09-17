//
//  AnonymousAuthTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 17.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class AnonymousAuthTests: XCTestCase {
    
    func testSignIn() {
        // Success
        var complection = AuthComplectionMock()
        var auth = AnonymousAuth(auth: nil, authComplection: complection)
        XCTAssertNotNil(try auth.signIn().toBlocking().first()?.element)
        // Error
        complection = AuthComplectionMock(error: AppError.unknown)
        auth = AnonymousAuth(auth: nil, authComplection: complection)
        XCTAssertEqual(try auth.signIn().toBlocking().first()?.error?.localizedDescription, AppError.unknown.localizedDescription)
    }
    
}
