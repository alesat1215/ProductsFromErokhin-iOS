//
//  AboutProductsViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 13.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class AboutProductsViewModelMockTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var viewModel: AboutProductsViewModelMock!
    private var dataSource: CoreDataSourceCollectionViewMock<AboutProducts>!
    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        viewModel = AboutProductsViewModelMock()
        dataSource = CoreDataSourceCollectionViewMock(fetchRequest: AboutProducts.fetchRequestWithSort())
    }

    override func tearDownWithError() throws {
        try AboutProducts.clearEntity(context: context)
    }
    
    func testAboutProducts() {
        var result: CoreDataSourceCollectionView<AboutProducts>?
        viewModel.aboutProducts().dematerialize()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertNil(result)
        viewModel.aboutProductsResult.accept(Event.next(dataSource))
        XCTAssertEqual(result, dataSource)
    }

}
