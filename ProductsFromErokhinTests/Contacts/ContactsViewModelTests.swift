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
    private var viewModel: ContactsViewModel!

    override func setUpWithError() throws {
        repository = AppRepositoryMock()
        viewModel = ContactsViewModelImpl(repository: repository)
    }
    
    func testContacts() {
        XCTAssertEqual(try viewModel.contacts().dematerialize().toBlocking().first(), repository.sellerContactsResult)
    }

}
