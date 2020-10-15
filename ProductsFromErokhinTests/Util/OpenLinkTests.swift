//
//  OpenLinkTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 15.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class OpenLinkTests: XCTestCase {
    
    func testOpen() {
        let app = UIApplicationMock()
        let viewModel = ContactsViewModelImpl(repository: nil, app: app)
        // Link is nil
        viewModel.open(link: nil)
        XCTAssertNil(app.canOpenURLParamResult)
        XCTAssertFalse(app.isCanOpenURL)
        XCTAssertNil(app.openResult)
        XCTAssertFalse(app.isOpen)
        // Link is empty
        viewModel.open(link: "")
        XCTAssertNil(app.canOpenURLParamResult)
        XCTAssertFalse(app.isCanOpenURL)
        XCTAssertNil(app.openResult)
        XCTAssertFalse(app.isOpen)
        // Link not empty, but can't open url
        app.canOpenURLResult = false
        viewModel.open(link: "test")
        XCTAssertNotNil(app.canOpenURLParamResult)
        XCTAssertTrue(app.isCanOpenURL)
        XCTAssertEqual(app.canOpenURLParamResult?.absoluteString, "test")
        XCTAssertNil(app.openResult)
        XCTAssertFalse(app.isOpen)
        // Link not empty, open url
        app.canOpenURLResult = true
        app.canOpenURLParamResult = nil
        app.isCanOpenURL = false
        viewModel.open(link: "test")
        XCTAssertNotNil(app.canOpenURLParamResult)
        XCTAssertTrue(app.isCanOpenURL)
        XCTAssertEqual(app.canOpenURLParamResult?.absoluteString, "test")
        XCTAssertNotNil(app.openResult)
        XCTAssertTrue(app.isOpen)
        XCTAssertEqual(app.openResult?.absoluteString, "test")
    }

}
