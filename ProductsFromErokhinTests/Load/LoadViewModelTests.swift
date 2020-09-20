//
//  LoadViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class LoadViewModelTests: XCTestCase {
    
    private var viewModel: LoadViewModel!
    private let repository = AppRepositoryMock()
    private let auth = AnonymousAuthMock()

    override func setUpWithError() throws {
        viewModel = LoadViewModel(repository: repository, anonymousAuth: auth)
    }
    
    func testAuth() {
        XCTAssertNotNil(try viewModel.auth().toBlocking().first())
    }
    
    func testLoadComplete() {
        // Complete
        XCTAssertTrue(try viewModel.loadComplete().toBlocking().first()?.element ?? false)
        // Uncomplete
        repository.titlesResult = []
        XCTAssertFalse(try viewModel.loadComplete().toBlocking().first()?.element ?? true)
    }

}
