//
//  LoadViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class LoadViewControllerTests: XCTestCase {
    
    private var controller: LoadViewController!
    private var viewModel: LoadViewModelMock!
    private var navigationController: UINavigationController!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoadViewController")
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        viewModel = LoadViewModelMock()
        controller.viewModel = viewModel
        
        controller.viewDidLoad()
    }
    
    func testLoadData() {
        // Internet unavailable
        XCTAssertTrue(controller.connectionError.isHidden)
        XCTAssertTrue(controller.activity.isAnimating)
        XCTAssertFalse(viewModel.isAuth)
        XCTAssertFalse(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        viewModel.nwAvailableResult.accept(false)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse(controller.connectionError.isHidden)
        XCTAssertFalse(controller.activity.isAnimating)
        XCTAssertFalse(viewModel.isAuth)
        XCTAssertFalse(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        // Internet available
        viewModel.nwAvailableResult.accept(true)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertTrue(controller.connectionError.isHidden)
        XCTAssertTrue(controller.activity.isAnimating)
        XCTAssertTrue(viewModel.isAuth)
        XCTAssertFalse(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        // Internet available. Auth error. Show message
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        viewModel.nwAvailableResult.accept(true)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)

        viewModel.authResult.accept(Event.error(AppError.unknown))

        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)

        XCTAssertNotNil(controller.presentedViewController)
        var alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertFalse(viewModel.isLoadComplete)
        // Trigger action OK
        var action = alertController.actions.first!
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        var block = action.value(forKey: "handler")
        var blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        var handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        // Internet available. Auth success. Load error. Show message
        viewModel.nwAvailableResult.accept(true)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        viewModel.authResult.accept(Event.next(()))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        viewModel.loadCompleteResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertTrue(viewModel.isLoadComplete)
        // Trigger action OK
        action = alertController.actions.first!
        block = action.value(forKey: "handler")
        blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        // Internet available. Auth success. Load success, completed. Tutorial isn't read. Navigate to Tutorial
        viewModel.isLoadComplete = false
        XCTAssertFalse(viewModel.isRead)
        
        viewModel.nwAvailableResult.accept(true)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        viewModel.authResult.accept(Event.next(()))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        viewModel.loadCompleteResult.accept(Event.next(()))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        XCTAssertTrue(controller.presentedViewController is UIPageViewController)
        XCTAssertTrue(viewModel.isRead)
        
        // Data were loading. Sequense must be completed
        controller.presentedViewController?.dismiss(animated: true)
        viewModel.isLoadComplete = false
        viewModel.isRead = false
        
        viewModel.nwAvailableResult.accept(true)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        viewModel.authResult.accept(Event.next(()))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)
        
        viewModel.loadCompleteResult.accept(Event.next(()))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isRead)
    }
    
    func testLoadDataTutorialIsRead() {
        // Internet available. Auth success. Load success, completed. Tutorial is read. Navigate to Start
        controller.presentedViewController?.dismiss(animated: true)
        viewModel.isLoadComplete = false
        viewModel.tutorialIsReadResult = true
        viewModel.isRead = false

        viewModel.nwAvailableResult.accept(true)

        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)

        viewModel.authResult.accept(Event.next(()))

        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)

        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isLoadComplete)
        XCTAssertFalse(viewModel.isRead)

        viewModel.loadCompleteResult.accept(Event.next(()))

        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)

        XCTAssertNotNil(controller.presentedViewController)
        XCTAssertTrue(controller.presentedViewController is UINavigationController)
        XCTAssertTrue(viewModel.isRead)
    }

}
