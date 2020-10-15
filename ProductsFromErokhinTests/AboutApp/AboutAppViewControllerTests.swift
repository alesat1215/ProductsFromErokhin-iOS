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
    
    func testSetupPrivacyActions() {
        // Error. Show message
        XCTAssertFalse(viewModel.isOpen)
        XCTAssertNil(viewModel.linkResult)
        
        controller.privacy.sendActions(for: .touchUpInside)
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        viewModel.aboutAppResult.accept(Event.error(AppError.unknown))
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
        controller.privacy.sendActions(for: .touchUpInside)
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        viewModel.aboutAppResult.accept(Event.next([]))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isOpen)
        XCTAssertNil(viewModel.linkResult)
        
        // Success
        controller.privacy.sendActions(for: .touchUpInside)
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        viewModel.aboutAppResult.accept(Event.next([aboutApp]))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isOpen)
        XCTAssertNotNil(viewModel.linkResult)
        XCTAssertEqual(viewModel.linkResult, aboutApp.privacy)
    }
    
    func testSetupUpdateActions() {
        // Error. Show message
        XCTAssertFalse(viewModel.isOpen)
        XCTAssertNil(viewModel.linkResult)
        
        controller.update.sendActions(for: .touchUpInside)
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        viewModel.aboutAppResult.accept(Event.error(AppError.unknown))
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
        controller.update.sendActions(for: .touchUpInside)
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        viewModel.aboutAppResult.accept(Event.next([]))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isOpen)
        XCTAssertNil(viewModel.linkResult)
        
        // Success
        controller.update.sendActions(for: .touchUpInside)
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        viewModel.aboutAppResult.accept(Event.next([aboutApp]))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isOpen)
        XCTAssertNotNil(viewModel.linkResult)
        XCTAssertEqual(viewModel.linkResult, aboutApp.appStore)
    }
    
    func testSetupUpdateVisibility() {
        XCTAssertFalse(controller.update.isHidden)
        viewModel.aboutAppResult.accept(Event.next([aboutApp]))
        XCTAssertFalse(controller.update.isHidden)
        aboutApp.version = viewModel.versionResult
        viewModel.aboutAppResult.accept(Event.next([aboutApp]))
        XCTAssertTrue(controller.update.isHidden)
    }

}
