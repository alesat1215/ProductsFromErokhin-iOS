//
//  Auth+RxTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 06.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import FirebaseAuth
@testable import ProductsFromErokhin

class Auth_RxTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    private var auth: AuthMock!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        auth = AuthMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSignInAnonymously() {
        var result: Event<Void>?
        auth.rx.signInAnonymously()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        // Auth result == nil. Error == nil. Not event
        XCTAssertNil(result)
        auth.completion?(nil, nil)
        XCTAssertNil(result)
        // Auth result == nil. Error. Sequence not completed
        auth.completion?(nil, AppError.unknown)
        XCTAssertEqual(result?.error?.localizedDescription, AppError.unknown.localizedDescription)
        auth.completion?(nil, AppError.context)
        XCTAssertEqual(result?.error?.localizedDescription, AppError.context.localizedDescription)
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
