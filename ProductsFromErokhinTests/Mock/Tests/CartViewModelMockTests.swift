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
    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        viewModel = CartViewModelMock()
    }
    
    func testInCartCount() {
        viewModel.inCartCountResult = "Test"
        XCTAssertEqual(try viewModel.inCartCount().toBlocking().first()!, viewModel.inCartCountResult)
    }
    
    func testClearCart() {
        XCTAssertFalse(viewModel.isClearCart)
        var result: Event<Void>?
        viewModel.clearCart().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        viewModel.clearCartResult.accept(Event.next(()))
        XCTAssertTrue(viewModel.isClearCart)
        XCTAssertNotNil(result)
    }
    
    func testProducts() {
        var result: CoreDataSourceTableView<Product>?
        let dataSource = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
        viewModel.products().dematerialize()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        viewModel.productsResult.accept(Event.next(dataSource))
        XCTAssertEqual(result, dataSource)
    }
    
    func testTotalInCart() {
        var result: Int?
        viewModel.totalInCart().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        viewModel.totalInCartResult.accept(3)
        XCTAssertEqual(result, 3)
    }
    
    func testWarning() {
        var result: String?
        let warning = "Warning"
        viewModel.warning().dematerialize()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        viewModel.warningResult.accept(Event.next(warning))
        XCTAssertEqual(result, warning)
    }
    
    func testWithoutWarning() {
        var result: Bool?
        viewModel.withoutWarning()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        viewModel.withoutWarningResult.accept(true)
        XCTAssertTrue(result!)
    }
    
    func testPhoneForOrder() {
        XCTAssertFalse(viewModel.isPhoneForOrder)
        XCTAssertThrowsError(try viewModel.phoneForOrder().dematerialize().toBlocking().first())
        XCTAssertTrue(viewModel.isPhoneForOrder)
    }
    
    func testCheckContact() {
        XCTAssertFalse(viewModel.isCheckContact)
        XCTAssertNotNil(try viewModel.checkContact(phone: "").toBlocking().first())
        XCTAssertTrue(viewModel.isCheckContact)
    }
    
    func testMessage() {
        XCTAssertFalse(viewModel.isMessage)
        XCTAssertEqual(try viewModel.message().toBlocking().first(), viewModel.messageResult)
        XCTAssertTrue(viewModel.isMessage)
    }

}
