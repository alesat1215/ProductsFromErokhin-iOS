//
//  MenuViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 27.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class MenuViewModelMockTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let viewModel = MenuViewModelMock()
    private let disposeBag = DisposeBag()
    
    func testGroups() {
        let dataSource = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
        var result: CoreDataSourceCollectionView<Group>?
        viewModel.groups().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        viewModel.groupsResult.accept(Event.next(dataSource))
        XCTAssertEqual(result, dataSource)
    }
    
    func testProducts() {
        let dataSource = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
        var result: CoreDataSourceTableView<Product>?
        viewModel.products().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        viewModel.productsResult.accept(Event.next(dataSource))
        XCTAssertEqual(result, dataSource)
    }

}
