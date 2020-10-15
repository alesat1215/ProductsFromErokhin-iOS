//
//  ContactsViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class ContactsViewModelTests: XCTestCase {
    private var repository: AppRepositoryMock!
    private var app: UIApplicationMock!
    private var viewModel: ContactsViewModel!

    override func setUpWithError() throws {
        repository = AppRepositoryMock()
        app = UIApplicationMock()
        viewModel = ContactsViewModelImpl(repository: repository, app: app)
    }
    
    func testContacts() {
        XCTAssertEqual(try viewModel.contacts().dematerialize().toBlocking().first(), repository.sellerContactsResult)
    }
    
    func testCall() {
        // Phone is nil
        viewModel.open(link: nil)
        XCTAssertNil(app.canOpenURLParamResult)
        XCTAssertFalse(app.isCanOpenURL)
        XCTAssertNil(app.openResult)
        XCTAssertFalse(app.isOpen)
        // Phone is empty
        viewModel.open(link: "")
        XCTAssertNil(app.canOpenURLParamResult)
        XCTAssertFalse(app.isCanOpenURL)
        XCTAssertNil(app.openResult)
        XCTAssertFalse(app.isOpen)
        // Phone not empty, but can't open url
        app.canOpenURLResult = false
        viewModel.open(link: "test")
        XCTAssertNotNil(app.canOpenURLParamResult)
        XCTAssertTrue(app.isCanOpenURL)
        XCTAssertEqual(app.canOpenURLParamResult?.absoluteString, "test")
        XCTAssertNil(app.openResult)
        XCTAssertFalse(app.isOpen)
        // Phone not empty, open url
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
