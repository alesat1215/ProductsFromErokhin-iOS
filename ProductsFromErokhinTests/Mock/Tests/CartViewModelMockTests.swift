//
//  CartViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 05.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class CartViewModelMockTests: XCTestCase {
    
    private var viewModel: CartViewModelMock!

    override func setUpWithError() throws {
        viewModel = CartViewModelMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInCartCount() {
        viewModel.inCartCountResult = "Test"
        XCTAssertEqual(try viewModel.inCartCount().toBlocking().first()!, viewModel.inCartCountResult)
    }
    
    func testClearCart() {
        XCTAssertFalse(viewModel.isClearCart)
        XCTAssertNoThrow(try viewModel.clearCart().get())
        XCTAssertTrue(viewModel.isClearCart)
    }
    
    func testProducts() {
        var result: CoreDataSourceTableView<Product>?
        let dataSource = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
        let disposeBag = DisposeBag()
        viewModel.products().dematerialize()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        viewModel.productsResult.accept(Event.next(dataSource))
        XCTAssertEqual(result, dataSource)
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
