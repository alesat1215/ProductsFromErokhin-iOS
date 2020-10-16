//
//  AboutProductsViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 13.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class AboutProductsViewModelTests: XCTestCase {
    
    private var repository: RepositoryMock!
    private var viewModel: AboutProductsViewModel!

    override func setUpWithError() throws {
        repository = RepositoryMock()
        viewModel = AboutProductsViewModelImpl(repository: repository)
    }
    
    func testAboutProducts() {
        XCTAssertEqual(try viewModel.aboutProducts().dematerialize().toBlocking().first(), repository.aboutProductsResult)
        XCTAssertEqual(repository.aboutProductsCellIdResult, ["aboutProducts0", "aboutProducts1"])
    }

}
