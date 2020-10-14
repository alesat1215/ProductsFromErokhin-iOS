//
//  UIApplicationMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class UIApplicationMockTests: XCTestCase {
    private var app: UIApplicationMock!
    private let url = URL(string: "test")!

    override func setUpWithError() throws {
        app = UIApplicationMock()
    }
    
    func testCanOpenURL() {
        XCTAssertNil(app.canOpenURLParamResult)
        XCTAssertFalse(app.isCanOpenURL)
        XCTAssertEqual(app.canOpenURL(url), app.canOpenURLResult)
        XCTAssertEqual(app.canOpenURLParamResult, url)
        XCTAssertTrue(app.isCanOpenURL)
    }
    
    func testOpen() {
        XCTAssertNil(app.openResult)
        XCTAssertFalse(app.isOpen)
        app.open(url, options: [:], completionHandler: nil)
        XCTAssertEqual(app.openResult, url)
        XCTAssertTrue(app.isOpen)
    }

}
