//
//  StartViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class StartViewModelMockTests: XCTestCase {
    
    private let viewModel = StartViewModelMock()
    private let disposeBag = DisposeBag()
    
    func testTitles() {
        let titles = [Titles(context: ContextMock())]
        var result: [Titles]?
        viewModel.titles().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        viewModel.titlesResult.accept(Event.next(titles))
        XCTAssertEqual(result, titles)
    }
    
    func testProducts() {
        let dataSource = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        var result: CoreDataSource<Product>?
        viewModel.products().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        viewModel.productsResult.accept(Event.next(dataSource))
        XCTAssertEqual(result, dataSource)
    }
    
    func testProducts2() {
        let dataSource = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        var result: CoreDataSource<Product>?
        viewModel.products2().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        viewModel.productsResult2.accept(Event.next(dataSource))
        XCTAssertEqual(result, dataSource)
    }

}
