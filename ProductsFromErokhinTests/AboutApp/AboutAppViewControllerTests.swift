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
    
    func testPrivacyActions() {
        // Error. Show message
        XCTAssertFalse(viewModel.isOpen)
        XCTAssertNil(viewModel.linkResult)
        controller.privacy.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertFalse(viewModel.isOpen)
        XCTAssertNil(viewModel.linkResult)
        // Trigger action OK
        let action = alertController.actions.first!
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        let block = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isOpen)
        XCTAssertNil(viewModel.linkResult)
        
        // Empty array of info
        viewModel.aboutAppResult = Event.next([])
        controller.privacy.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isOpen)
        XCTAssertNil(viewModel.linkResult)
        
        // Success
        viewModel.aboutAppResult = Event.next([aboutApp])
        controller.privacy.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isOpen)
        XCTAssertNotNil(viewModel.linkResult)
        XCTAssertEqual(viewModel.linkResult, aboutApp.privacy)
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
