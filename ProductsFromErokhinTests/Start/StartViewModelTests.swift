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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTitles() {
        let titles = [Titles(context: context)]
        var result: [Titles]?
        viewModel.titles().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        repository.titlesResult.accept(Event.next(titles))
        XCTAssertEqual(result, titles)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
