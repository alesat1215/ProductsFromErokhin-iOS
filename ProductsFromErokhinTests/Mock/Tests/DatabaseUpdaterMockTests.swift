//
//  DatabaseUpdaterMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class DatabaseUpdaterMockTests: XCTestCase {
    
    func testSync() throws {
        let updater = DatabaseUpdaterMock()
        // Success
        XCTAssertFalse(updater.isSync)
        var sync: Observable<Event<Void>> = updater.sync()
        XCTAssertNil(try sync.toBlocking().first())
        XCTAssertTrue(updater.isSync)
        // Error
        updater.isSync = false
        updater.error = AppError.unknown
        XCTAssertFalse(updater.isSync)
        sync = updater.sync()
        XCTAssertEqual(try sync.toBlocking().first()?.error?.localizedDescription, AppError.unknown.localizedDescription)
        XCTAssertTrue(updater.isSync)
    }

}
