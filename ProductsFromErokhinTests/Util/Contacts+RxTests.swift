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
    
    private var store: CNContactStoreMock!

    override func setUpWithError() throws {
        store = CNContactStoreMock()
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
    
    func testUnifiedContacts() {
        // OnNext
        XCTAssertEqual(try store.rx.unifiedContacts(matching: NSPredicate(), keysToFetch: []).toBlocking().first(), store.unifiedContactsResult)
        // OnError
        store.unifiedContactsResultThrow = AppError.unknown
        XCTAssertThrowsError(try store.rx.unifiedContacts(matching: NSPredicate(), keysToFetch: []).toBlocking().first())
    }

}
