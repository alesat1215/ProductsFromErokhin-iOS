//
//  AboutAppViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 15.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class AboutAppViewModelTests: XCTestCase {
    private var repository: AppRepositoryMock!
    private var viewModel: AboutAppViewModel!

    override func setUpWithError() throws {
        repository = AppRepositoryMock()
        viewModel = AboutAppViewModelImpl(repository: repository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAboutApp() {
        XCTAssertEqual(try viewModel.aboutApp().dematerialize().toBlocking().first(), repository.aboutAppResult)
    }
    
    func testName() {
        XCTAssertEqual(viewModel.name(), Bundle.main.infoDictionary!["CFBundleName"] as! String)
    }
    
    func testVersion() {
        let version = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) (\(Bundle.main.infoDictionary!["CFBundleVersion"] as! String))"
        XCTAssertEqual(viewModel.version(), version)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
