//
//  AboutAppViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 15.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class AboutAppViewModelMockTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    private var viewModel: AboutAppViewModelMock!

    override func setUpWithError() throws {
        viewModel = AboutAppViewModelMock()
    }

    func testAboutApp() {
//        var result: [AboutApp]?
//        viewModel.aboutApp().dematerialize()
//            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
//        XCTAssertNil(result)
//        viewModel.aboutAppResult.accept(Event.next([]))
//        XCTAssertNotNil(result)
    }
    
    func testName() {
        XCTAssertEqual(viewModel.name(), viewModel.nameResult)
    }
    
    func testVersion() {
        XCTAssertEqual(viewModel.version(), viewModel.versionResult)
    }
    
    func testOpen() {
        XCTAssertNil(viewModel.linkResult)
        XCTAssertFalse(viewModel.isOpen)
        viewModel.open(link: "test")
        XCTAssertEqual(viewModel.linkResult, "test")
        XCTAssertTrue(viewModel.isOpen)
    }

}
