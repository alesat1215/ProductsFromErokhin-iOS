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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTitles() {
        let disposeBag = DisposeBag()
        let titles = [Titles(context: ContextMock())]
        var result: [Titles]?
        viewModel.titles().subscribe(onNext: { result = $0.element }).disposed(by: disposeBag)
        viewModel.titlesResult.accept(Event.next(titles))
        XCTAssertEqual(result, titles)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
