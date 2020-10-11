//
//  PagesDataSourceMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class PagesDataSourceMockTests: XCTestCase {
    
    func testIsLastPage() {
        let dataSource = PagesDataSourceMock<Instruction>()
        XCTAssertEqual(dataSource.isLastPage(UIViewController()), dataSource.isLastPageResult)
    }

}
