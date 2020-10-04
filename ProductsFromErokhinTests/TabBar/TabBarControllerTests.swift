//
//  TabBarControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class TabBarControllerTests: XCTestCase {
    
    private var controller: TabBarController!
    private var viewModel: CartViewModelMock!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Outlets
    private var clearCart = UIButton()

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController")
        viewModel = CartViewModelMock()
        controller.viewModel = viewModel
        // Set outlets
        controller.clearCart = clearCart
        
        let window = UIWindow()
        window.rootViewController = controller
        window.makeKeyAndVisible()
        
        controller.viewDidLoad()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 2)
        XCTAssertEqual(alertController.actions.first?.style, .cancel)
        XCTAssertEqual(alertController.actions.first?.title, "CANCEL")
        XCTAssertEqual(alertController.actions[1].style, .destructive)
        XCTAssertEqual(alertController.actions[1].title, "OK")
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
