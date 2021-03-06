//
//  TabBarControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class TabBarControllerTests: XCTestCase {
    
    private var controller: TabBarController!
    private var viewModel: CartViewModelMock!
    private var navigationController: UINavigationController!

    override func setUpWithError() throws {
        viewModel = CartViewModelMock()
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController")
        controller.viewModel = viewModel
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
    }
    
    func testBindCartCount() {
        // Badge is empty, clearCart disabled
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        XCTAssertNil(controller.tabBar.items?.first(where: { $0.tag == 2 })?.badgeValue)
        XCTAssertFalse(controller.clearCart.isEnabled)
        // Badge is not empty, clearCart enabled
        viewModel.inCartCountResult = "3"
        controller.viewDidLoad()
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        XCTAssertEqual(controller.tabBar.items?.first(where: { $0.tag == 2 })?.badgeValue, "3")
        XCTAssertTrue(controller.clearCart.isEnabled)
    }
    
    func testSetupClearCartActionCANCEL() {
        // Tap clearCart than tap CANCEL button
        XCTAssertNil(controller.presentedViewController)
        controller.clearCart.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 2)
        XCTAssertEqual(alertController.actions.first?.style, .cancel)
        XCTAssertEqual(alertController.actions.first?.title, NSLocalizedString("cancel", comment: ""))
        XCTAssertEqual(alertController.actions[1].style, .destructive)
        XCTAssertEqual(alertController.actions[1].title, NSLocalizedString("clear", comment: ""))
        XCTAssertFalse(viewModel.isClearCart)
        // Trigger action CANCEL
        let action = alertController.actions.first!
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        let block = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isClearCart)
    }
    
    func testSetupClearCartActionOKButError() {
        // Tap clearCart than tap OK button
        XCTAssertNil(controller.presentedViewController)
        controller.clearCart.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        var alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 2)
        XCTAssertEqual(alertController.actions.first?.style, .cancel)
        XCTAssertEqual(alertController.actions.first?.title, NSLocalizedString("cancel", comment: ""))
        XCTAssertEqual(alertController.actions[1].style, .destructive)
        XCTAssertEqual(alertController.actions[1].title, NSLocalizedString("clear", comment: ""))
        XCTAssertFalse(viewModel.isClearCart)
        // Trigger action Clear
        var action = alertController.actions[1]
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        var block = action.value(forKey: "handler")
        var blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        var handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        viewModel.clearCartResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isClearCart)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        alertController = controller.presentedViewController as! UIAlertController
        
        XCTAssertEqual(alertController.actions.count, 1)
        // Trigger action Cancel
        action = alertController.actions[0]
        block = action.value(forKey: "handler")
        blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
    }
    
    func testSetupClearCartAction() {
        // Tap clearCart than tap OK button
        XCTAssertNil(controller.presentedViewController)
        
        controller.clearCart.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 2)
        XCTAssertEqual(alertController.actions.first?.style, .cancel)
        XCTAssertEqual(alertController.actions.first?.title, NSLocalizedString("cancel", comment: ""))
        XCTAssertEqual(alertController.actions[1].style, .destructive)
        XCTAssertEqual(alertController.actions[1].title, NSLocalizedString("clear", comment: ""))
        XCTAssertFalse(viewModel.isClearCart)
        // Trigger action OK
        let action = alertController.actions[1]
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        let block = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        viewModel.clearCartResult.accept(Event.next(()))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isClearCart)
    }

}
