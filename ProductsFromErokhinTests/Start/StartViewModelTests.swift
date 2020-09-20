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
    private let context = ContextMock()
    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repository = AppRepositoryMock()
        viewModel = StartViewModel(repository: repository)
    }
    
    func testTitles() {
        let titles = [Titles(context: context)]
        var result: [Titles]?
        viewModel.titles().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        repository.titlesResult.accept(Event.next(titles))
        XCTAssertEqual(result, titles)
    }
    
    func testProducts() {
        let products = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        var result: CoreDataSource<Product>?
        XCTAssertNil(repository.predicate)
        XCTAssertNil(repository.cellId)
        viewModel.products().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        repository.productsResult.accept(Event.next(products))
        XCTAssertEqual(result, products)
        XCTAssertNotNil(repository.predicate)
        XCTAssertNotNil(repository.cellId)
    }
    
    func testProducts2() {
        let products = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        var result: CoreDataSource<Product>?
        XCTAssertNil(repository.predicate)
        XCTAssertNil(repository.cellId)
        viewModel.products2().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        repository.productsResult.accept(Event.next(products))
        XCTAssertEqual(result, products)
        XCTAssertNotNil(repository.predicate)
        XCTAssertNotNil(repository.cellId)
    }

}
