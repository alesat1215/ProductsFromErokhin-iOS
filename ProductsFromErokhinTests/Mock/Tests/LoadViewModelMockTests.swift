//
//  LoadViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 21.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift

class LoadViewModelMockTests: XCTestCase {
    
    private var viewModel: LoadViewModelMock!

    override func setUpWithError() throws {
        viewModel = LoadViewModelMock()
    }
    
//    func testAuth() {
//        XCTAssertEqual(try viewModel.auth().toBlocking().first()?.error?.localizedDescription, viewModel.authResult.error?.localizedDescription)
//    }
    
    func testLoadComplete() {
        let complete = Event.next(true)
        var result: Event<Bool>?
        let disposeBag = DisposeBag()
        viewModel.loadComplete().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        viewModel.loadCompleteResult.accept(Event.next(true))
        XCTAssertEqual(result?.element, complete.element)
    }

}
