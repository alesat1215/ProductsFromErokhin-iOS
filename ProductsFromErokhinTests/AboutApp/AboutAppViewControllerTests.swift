//
//  AboutAppViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 15.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class AboutAppViewControllerTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var aboutApp: AboutApp!
    private var controller: AboutAppViewController!
    private var viewModel: AboutAppViewModelMock!
    private var navigationController: UINavigationController!

    override func setUpWithError() throws {
        aboutApp = AboutApp(context: context)
        aboutApp.version = "version"
        aboutApp.privacy = "https://apps.apple.com"
        aboutApp.appStore = "https://apps.apple.com"
        
        viewModel = AboutAppViewModelMock()
        
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AboutAppViewController")
        controller.viewModel = viewModel
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
    }

    override func tearDownWithError() throws {
        try AboutApp.clearEntity(context: context)
    }
    
    func testBindInfo() {
        XCTAssertEqual(controller.name.text, viewModel.nameResult)
        XCTAssertEqual(controller.version.text, viewModel.versionResult)
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
