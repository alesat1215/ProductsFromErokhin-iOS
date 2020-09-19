//
//  AnonymousAuthTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 17.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import FirebaseAuth
@testable import ProductsFromErokhin

class AnonymousAuthTests: XCTestCase {
    
    func testSignIn() {
        // Success
        let complection = AuthComplectionMock()
        var auth = AnonymousAuth(auth: nil, authComplection: complection)
        XCTAssertNotNil(try auth.signIn().toBlocking().first()?.element)
        // Error
        complection.error = AppError.unknown
        auth = AnonymousAuth(auth: nil, authComplection: complection)
        XCTAssertEqual(try auth.signIn().toBlocking().first()?.error?.localizedDescription, AppError.unknown.localizedDescription)
    }
    
    func testResult() {
        let disposeBag = DisposeBag()
        let complection = AuthComplection()
        var result: (result: AuthDataResult?, error: Error?)?
        complection.result().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        complection.complection(result: nil, error: nil)
        XCTAssertNotNil(result)
    }
    
}
