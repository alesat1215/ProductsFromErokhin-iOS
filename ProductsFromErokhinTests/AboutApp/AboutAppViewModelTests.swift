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
    private var repository: RepositoryMock!
    private var viewModel: AboutAppViewModel!

    override func setUpWithError() throws {
        repository = RepositoryMock()
        viewModel = AboutAppViewModelImpl(repository: repository)
    }
    
    func testAboutApp() {
        XCTAssertEqual(try viewModel.aboutApp().dematerialize().toBlocking().first(), repository.aboutAppResult)
    }
    
    func testName() {
        XCTAssertEqual(viewModel.name(), Bundle.main.localizedInfoDictionary!["CFBundleDisplayName"] as! String)
    }
    
    func testVersion() {
        let version = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) (\(Bundle.main.infoDictionary!["CFBundleVersion"] as! String))"
        XCTAssertEqual(viewModel.version(), version)
    }

}
