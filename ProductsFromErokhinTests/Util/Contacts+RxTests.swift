//
//  Contacts+RxTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 03.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import Contacts
import RxSwift
@testable import ProductsFromErokhin

class Contacts_RxTests: XCTestCase {
    
    var store: CNContactStoreMock!

    override func setUpWithError() throws {
        store = CNContactStoreMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestAccess() {
        let disposeBag = DisposeBag()
        var result = false
        store.rx.requestAccess(for: .contacts).subscribe(onNext: {
            result = $0
        }).disposed(by: disposeBag)
        XCTAssertFalse(result)
        store.completionHandler?(true, nil)
        XCTAssertTrue(result)
        // Check that sequence is completed & result not changed
        store.completionHandler?(false, nil)
        XCTAssertTrue(result)
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
