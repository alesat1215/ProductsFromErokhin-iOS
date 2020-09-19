//
//  AppRepositoryTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class AppRepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testProducts() throws {
        let updater = DatabaseUpdaterMock()
        let context = ContextMock()
        let repository = AppRepository(updater: updater, context: context)
        // Success
        XCTAssertFalse(updater.isSync)
        XCTAssertFalse(context.isFetch)
        XCTAssertNotNil(try repository.products(cellId: "").toBlocking().first()?.element)
        XCTAssertTrue(updater.isSync)
        XCTAssertTrue(context.isFetch)
        // Error
        updater.isSync = false
        context.isFetch = false
        updater.error = AppError.unknown
        XCTAssertNotNil(try repository.products(cellId: "").toBlocking().first()?.element)
        XCTAssertTrue(updater.isSync)
        XCTAssertTrue(context.isFetch)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
