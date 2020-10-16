//
//  MenuViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 27.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class MenuViewModelTests: XCTestCase {
    
    private var repository: RepositoryMock!
    private var viewModel: MenuViewModel!

    override func setUpWithError() throws {
        repository = RepositoryMock()
        viewModel = MenuViewModelImpl(repository: repository)
    }
    
    func testGroups() {
        XCTAssertEqual(try viewModel.groups().toBlocking().first()?.element, repository.groupsResult)
    }
    
    func testProducts() {
        XCTAssertNil(repository.predicateProductsTableView)
        XCTAssertNil(repository.cellIdProductsTableView)
        XCTAssertEqual(try viewModel.products().toBlocking().first()?.element, repository.productsResultTableView)
        XCTAssertNil(repository.predicateProductsTableView)
        XCTAssertNotNil(repository.cellIdProductsTableView)
    }

}
