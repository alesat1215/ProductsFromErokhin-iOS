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
    
    private var repository: AppRepositoryMock!
    private var viewModel: MenuViewModel!

    override func setUpWithError() throws {
        repository = AppRepositoryMock()
        viewModel = MenuViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGroups() {
        XCTAssertEqual(try viewModel.groups().toBlocking().first()?.element, repository.groupsResult)
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
