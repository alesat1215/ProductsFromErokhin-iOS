//
//  CartViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class CartViewControllerTests: XCTestCase {
    
    private var controller: CartViewController!
    private var viewModel: CartViewModelMock!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var navigationController: UINavigationController!
    // Outlets
    private var products: TableViewMock!
    private var orderWarning: UILabel!
    private var resultSum: UILabel!
    private var send: UIButton!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CartViewController")
        
        // Set views
        products = TableViewMock()
        orderWarning = UILabel()
        resultSum = UILabel()
        send = UIButton()
        // Set outlets
        controller.orderWarning = orderWarning
        controller.resultSum = resultSum
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        // Set viewModel & products
        viewModel = CartViewModelMock()
        controller.viewModel = viewModel
        controller.products = products
        controller.send = send
        
        controller.viewDidLoad()
    }
    
    func testPrepare() {
        let tableView = TableViewMock()
        let viewController = UIViewController()
        viewController.view = tableView
        let productsSegueId = "productsSegueId"
        controller.products = nil
        controller.prepare(for: UIStoryboardSegue(identifier: "test", source: UIViewController(), destination: viewController), sender: nil)
        XCTAssertNil(controller.products)
        controller.prepare(for: UIStoryboardSegue(identifier: productsSegueId, source: UIViewController(), destination: viewController), sender: nil)
        XCTAssertEqual(controller.products, tableView)
    }
    
    func testBindProducts() {
        // Error. Show message
        XCTAssertNil(products.dataSource)
        XCTAssertFalse(products.isReload)
        XCTAssertNil(controller.navigationController?.presentedViewController)
        viewModel.productsResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.navigationController?.presentedViewController)
        let alertController = controller.navigationController?.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(products.dataSource)
        XCTAssertFalse(products.isReload)
        // Trigger action OK
        let action = alertController.actions.first!
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        let block = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.navigationController?.presentedViewController)
        XCTAssertNil(products.dataSource)
        XCTAssertFalse(products.isReload)
        
        // Success
        let dataSource = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
        viewModel.productsResult.accept(Event.next(dataSource))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(controller.products.dataSource as! CoreDataSourceTableViewMock, dataSource)
        XCTAssertTrue((controller.products as! TableViewMock).isReload)
    }
    
    func testBindResult() {
        viewModel.totalInCartResult.accept(5)
        XCTAssertEqual(controller.resultSum.text, "5 ₽")
        XCTAssertTrue(controller.send.isEnabled)
        viewModel.totalInCartResult.accept(0)
        XCTAssertEqual(controller.resultSum.text, "0 ₽")
        XCTAssertFalse(controller.send.isEnabled)
    }
    
    func testbindWarning() {
        viewModel.withoutWarningResult.accept(true)
        XCTAssertTrue(controller.orderWarning.isHidden)
        viewModel.withoutWarningResult.accept(false)
        XCTAssertFalse(controller.orderWarning.isHidden)
        
        // Error. Show message
        controller.orderWarning.text = nil
        XCTAssertNil(controller.navigationController?.presentedViewController)
        viewModel.warningResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.navigationController?.presentedViewController)
        let alertController = controller.navigationController?.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(controller.orderWarning.text)
        // Trigger action OK
        let action = alertController.actions.first!
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        let block = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.navigationController?.presentedViewController)
        XCTAssertNil(controller.orderWarning.text)
        
        // Success
        viewModel.warningResult.accept(Event.next("Warning"))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.navigationController?.presentedViewController)
        XCTAssertEqual(controller.orderWarning.text, "Warning")
    }
    
    func testSetupSendAction() {
        // phoneForOrder with error. Show message
        XCTAssertFalse(viewModel.isPhoneForOrder)
        XCTAssertFalse(viewModel.isCheckContact)
        XCTAssertFalse(viewModel.isMessage)
        XCTAssertFalse(viewModel.isClearCart)
        XCTAssertNil(controller.presentedViewController)
        
        controller.send.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        var alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertFalse(viewModel.isCheckContact)
        XCTAssertFalse(viewModel.isMessage)
        XCTAssertFalse(viewModel.isClearCart)
        
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
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertFalse(viewModel.isCheckContact)
        XCTAssertFalse(viewModel.isMessage)
        XCTAssertFalse(viewModel.isClearCart)
        
        // phoneForOrder success. Select messenger for send error. Show message
//        viewModel.isPhoneForOrder = false
//        viewModel.phoneForOrderResult = Event.next("phone")
//
//        controller.send.sendActions(for: .touchUpInside)
//
//        expectation(description: "wait 1 second").isInverted = true
//        waitForExpectations(timeout: 1)
//
//        XCTAssertNotNil(controller.presentedViewController)
//        var activityController = controller.presentedViewController as! UIActivityViewController
//
//        XCTAssertTrue(viewModel.isPhoneForOrder)
//        XCTAssertTrue(viewModel.isCheckContact)
//        XCTAssertTrue(viewModel.isMessage)
//        XCTAssertFalse(viewModel.isClearCart)
//
//        activityController.dismiss(animated: true)
//        activityController.completionWithItemsHandler?(nil, false, nil, AppError.unknown)
//
//        expectation(description: "wait 1 second").isInverted = true
//        waitForExpectations(timeout: 1)
//
//        XCTAssertNotNil(controller.presentedViewController)
//        alertController = controller.presentedViewController as! UIAlertController
//        XCTAssertEqual(alertController.actions.count, 1)
//        XCTAssertEqual(alertController.actions.first?.style, .default)
//        XCTAssertEqual(alertController.actions.first?.title, "OK")
//        XCTAssertTrue(viewModel.isPhoneForOrder)
//        XCTAssertTrue(viewModel.isCheckContact)
//        XCTAssertTrue(viewModel.isMessage)
//        XCTAssertFalse(viewModel.isClearCart)
//
//        // Trigger action OK
//        action = alertController.actions.first!
//        block = action.value(forKey: "handler")
//        blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
//        handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
//        handler(action)
//
//        expectation(description: "wait 1 second").isInverted = true
//        waitForExpectations(timeout: 1)
//
//        XCTAssertNil(controller.presentedViewController)
//        XCTAssertTrue(viewModel.isPhoneForOrder)
//        XCTAssertTrue(viewModel.isCheckContact)
//        XCTAssertTrue(viewModel.isMessage)
//        XCTAssertFalse(viewModel.isClearCart)
        
        // phoneForOrder success. Select messenger success but not completed
        viewModel.isPhoneForOrder = false
        viewModel.isCheckContact = false
        viewModel.isMessage = false
        viewModel.phoneForOrderResult = Event.next(("phone"))
        
        controller.send.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        var activityController = controller.presentedViewController as! UIActivityViewController
        
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertTrue(viewModel.isCheckContact)
        XCTAssertTrue(viewModel.isMessage)
        XCTAssertFalse(viewModel.isClearCart)
        
        activityController.dismiss(animated: false)
        activityController.completionWithItemsHandler?(nil, false, nil, nil)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertTrue(viewModel.isCheckContact)
        XCTAssertTrue(viewModel.isMessage)
        XCTAssertFalse(viewModel.isClearCart)
        
        // phoneForOrder success. Select messenger success, completed. Clear cart with error. Show message
        viewModel.isPhoneForOrder = false
        viewModel.isCheckContact = false
        viewModel.isMessage = false
        
        controller.send.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        activityController = controller.presentedViewController as! UIActivityViewController
        
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertTrue(viewModel.isCheckContact)
        XCTAssertTrue(viewModel.isMessage)
        XCTAssertFalse(viewModel.isClearCart)
        
        activityController.dismiss(animated: false)
        activityController.completionWithItemsHandler?(nil, true, nil, nil)
        viewModel.clearCartResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertTrue(viewModel.isCheckContact)
        XCTAssertTrue(viewModel.isMessage)
        XCTAssertTrue(viewModel.isClearCart)
        
        alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        
        // Trigger action OK
        action = alertController.actions.first!
        block = action.value(forKey: "handler")
        blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertTrue(viewModel.isCheckContact)
        XCTAssertTrue(viewModel.isMessage)
        XCTAssertTrue(viewModel.isClearCart)
        
        // phoneForOrder success. Select messenger success, completed. Clear cart success
        viewModel.isPhoneForOrder = false
        viewModel.isCheckContact = false
        viewModel.isMessage = false
        viewModel.isClearCart = false
        
        controller.send.sendActions(for: .touchUpInside)
        viewModel.clearCartResult.accept(Event.next(()))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        activityController = controller.presentedViewController as! UIActivityViewController
        
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertTrue(viewModel.isCheckContact)
        XCTAssertTrue(viewModel.isMessage)
        XCTAssertFalse(viewModel.isClearCart)
        
        activityController.dismiss(animated: false)
        activityController.completionWithItemsHandler?(nil, true, nil, nil)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertTrue(viewModel.isPhoneForOrder)
        XCTAssertTrue(viewModel.isCheckContact)
        XCTAssertTrue(viewModel.isMessage)
        XCTAssertTrue(viewModel.isClearCart)
    }

}
