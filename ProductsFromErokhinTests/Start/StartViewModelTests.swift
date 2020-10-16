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
    
    private var repository: RepositoryMock!
    private var viewModel: StartViewModel!

    override func setUpWithError() throws {
        repository = RepositoryMock()
        viewModel = StartViewModel(repository: repository)
    }
    
    func testTitles() {
        XCTAssertEqual(try viewModel.titles().toBlocking().first()?.element, repository.titlesResult)
    }
    
    func testProducts() {
        XCTAssertNil(repository.predicateProductsCollectionView)
        XCTAssertNil(repository.cellIdProductsCollectionView)
        XCTAssertEqual(try viewModel.products().toBlocking().first()?.element, repository.productsResultCollectionView)
        XCTAssertNotNil(repository.predicateProductsCollectionView)
        XCTAssertNotNil(repository.cellIdProductsCollectionView)
    }
    
    func testProducts2() {
        XCTAssertNil(repository.predicateProductsCollectionView)
        XCTAssertNil(repository.cellIdProductsCollectionView)
        XCTAssertEqual(try viewModel.products2().toBlocking().first()?.element, repository.productsResultCollectionView)
        XCTAssertNotNil(repository.predicateProductsCollectionView)
        XCTAssertNotNil(repository.cellIdProductsCollectionView)
    }

}
