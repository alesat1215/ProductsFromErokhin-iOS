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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testContacts() {
        XCTAssertEqual(try viewModel.contacts().dematerialize().toBlocking().first(), repository.sellerContactsResult)
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
