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
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        viewModel = LoadViewModelMock()
        disposeBag = DisposeBag()
    }
    
    func testNWAvailable() {
        var result: Bool?
        viewModel.nwAvailable().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertNil(result)
        viewModel.nwAvailableResult.accept(true)
        XCTAssertTrue(result!)
    }
    
    func testAuth() {
        var result: Event<Void>?
        viewModel.auth().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertNil(result)
        viewModel.authResult.accept(Event.next(()))
        XCTAssertNotNil(result)
    }
    
    func testLoadComplete() {
        var result: Event<Void>?
        viewModel.loadComplete().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        viewModel.loadCompleteResult.accept(Event.next(()))
        XCTAssertNotNil(result)
    }
    
    func testTutorialIsRead() {
        XCTAssertFalse(viewModel.isRead)
        XCTAssertEqual(viewModel.tutorialIsRead(), viewModel.tutorialIsReadResult)
        XCTAssertTrue(viewModel.isRead)
    }

}
