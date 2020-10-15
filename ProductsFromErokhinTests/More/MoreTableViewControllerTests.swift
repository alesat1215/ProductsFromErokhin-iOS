//
//  MoreTableViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 15.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class MoreTableViewControllerTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var aboutApp: AboutApp!
    private var controller: MoreTableViewController!
    private var viewModel: AboutAppViewModelMock!
    private var navigationController: UINavigationController!

    override func setUpWithError() throws {
        aboutApp = AboutApp(context: context)
        aboutApp.version = "version"
        aboutApp.privacy = "https://apps.apple.com"
        aboutApp.appStore = "https://apps.apple.com"
        
        viewModel = AboutAppViewModelMock()
        
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MoreTableViewController")
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
    
    func testSetupShareAction() {
        // Not share. Invalid indexPath
        XCTAssertNil(controller.presentedViewController)
        controller.tableView.delegate?.tableView?(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        XCTAssertFalse(viewModel.isAboutApp)
        XCTAssertNil(controller.presentedViewController)
        // Error. Show message
        controller.tableView.delegate?.tableView?(controller.tableView, didSelectRowAt: IndexPath(row: 3, section: 0))
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
        XCTAssertTrue(viewModel.isAboutApp)
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
        XCTAssertTrue(viewModel.isAboutApp)
        
        // Empty array of aboutApp
        viewModel.isAboutApp = false
        controller.tableView.delegate?.tableView?(controller.tableView, didSelectRowAt: IndexPath(row: 3, section: 0))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        viewModel.aboutAppResult.accept(Event.next([]))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isAboutApp)
        
        // Success
        viewModel.isAboutApp = false
        controller.tableView.delegate?.tableView?(controller.tableView, didSelectRowAt: IndexPath(row: 3, section: 0))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        viewModel.aboutAppResult.accept(Event.next([aboutApp]))
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        XCTAssertTrue(controller.presentedViewController is UIActivityViewController)
        XCTAssertTrue(viewModel.isAboutApp)
    }

}
