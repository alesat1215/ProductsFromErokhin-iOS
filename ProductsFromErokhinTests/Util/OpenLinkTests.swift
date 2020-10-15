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
    
    class OpenLinkMock: OpenLink {
        let _app = UIApplicationMock()
        var app: UIApplicationMethods? {
            _app
        }
    }
    
    func testOpen() {
        let openLink = OpenLinkMock()
        // Link is nil
        openLink.open(link: nil)
        XCTAssertNil(openLink._app.canOpenURLParamResult)
        XCTAssertFalse(openLink._app.isCanOpenURL)
        XCTAssertNil(openLink._app.openResult)
        XCTAssertFalse(openLink._app.isOpen)
        // Link is empty
        openLink.open(link: "")
        XCTAssertNil(openLink._app.canOpenURLParamResult)
        XCTAssertFalse(openLink._app.isCanOpenURL)
        XCTAssertNil(openLink._app.openResult)
        XCTAssertFalse(openLink._app.isOpen)
        // Link not empty, but can't open url
        openLink._app.canOpenURLResult = false
        openLink.open(link: "test")
        XCTAssertNotNil(openLink._app.canOpenURLParamResult)
        XCTAssertTrue(openLink._app.isCanOpenURL)
        XCTAssertEqual(openLink._app.canOpenURLParamResult?.absoluteString, "test")
        XCTAssertNil(openLink._app.openResult)
        XCTAssertFalse(openLink._app.isOpen)
        // Link not empty, open url
        openLink._app.canOpenURLResult = true
        openLink._app.canOpenURLParamResult = nil
        openLink._app.isCanOpenURL = false
        openLink.open(link: "test")
        XCTAssertNotNil(openLink._app.canOpenURLParamResult)
        XCTAssertTrue(openLink._app.isCanOpenURL)
        XCTAssertEqual(openLink._app.canOpenURLParamResult?.absoluteString, "test")
        XCTAssertNotNil(openLink._app.openResult)
        XCTAssertTrue(openLink._app.isOpen)
        XCTAssertEqual(openLink._app.openResult?.absoluteString, "test")
    }

}
