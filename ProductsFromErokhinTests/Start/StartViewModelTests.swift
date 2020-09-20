//
//  StartViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class StartViewModelTests: XCTestCase {
    
    private var repository: AppRepositoryMock!
    private var viewModel: StartViewModel!

    override func setUpWithError() throws {
        repository = AppRepositoryMock()
        viewModel = StartViewModel(repository: repository)
    }
    
    func testTitles() {
        XCTAssertEqual(try viewModel.titles().toBlocking().first()?.element, repository.titlesResult)
    }
    
    func testProducts() {
        XCTAssertNil(repository.predicate)
        XCTAssertNil(repository.cellId)
        XCTAssertEqual(try viewModel.products().toBlocking().first()?.element, repository.productsResult)
        XCTAssertNotNil(repository.predicate)
        XCTAssertNotNil(repository.cellId)
    }
    
    func testProducts2() {
        XCTAssertNil(repository.predicate)
        XCTAssertNil(repository.cellId)
        XCTAssertEqual(try viewModel.products2().toBlocking().first()?.element, repository.productsResult)
        XCTAssertNotNil(repository.predicate)
        XCTAssertNotNil(repository.cellId)
    }

}
