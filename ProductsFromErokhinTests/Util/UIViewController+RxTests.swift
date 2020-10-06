//
//  UIViewController+RxTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 03.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class UIViewController_RxTests: XCTestCase {
    
    private var controller: UIViewController!

    override func setUpWithError() throws {
        controller = UIViewController()
        let window = UIWindow()
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    func testActivity() {
        XCTAssertNil(controller.presentedViewController)
        let disposeBag = DisposeBag()
        var result: (Bool, Error?)?
        controller.rx.activity(activityItems: []).subscribe(onNext: {
            result = $0
        }).disposed(by: disposeBag)
        XCTAssertNotNil(controller.presentedViewController)
        let activityController = controller.presentedViewController as! UIActivityViewController
        XCTAssertNil(result)
        // First call
        activityController.completionWithItemsHandler?(nil, true, nil, AppError.unknown)
        XCTAssertTrue(result!.0)
        XCTAssertEqual(result?.1?.localizedDescription, AppError.unknown.localizedDescription)
        // Second call. Result must not be changed, because sequence is completed
        activityController.completionWithItemsHandler?(nil, false, nil, AppError.group)
        XCTAssertTrue(result!.0)
        XCTAssertEqual(result?.1?.localizedDescription, AppError.unknown.localizedDescription)
    }
    
    func testShowMessageWithEvent() throws {
        XCTAssertNil(controller.presentedViewController)
        let disposeBag = DisposeBag()
        var result: Void?
        controller.rx.showMessage("", withEvent: true).subscribe(onNext: {
            result = $0
        }).disposed(by: disposeBag)
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(result)
        // Trigger action
        let action = alertController.actions.first!
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        let block = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        // Check result
        XCTAssertNotNil(result)
    }
    
    func testShowMessageWithoutEvent() throws {
        XCTAssertNil(controller.presentedViewController)
        let disposeBag = DisposeBag()
        var result: Void?
        controller.rx.showMessage("").subscribe(onNext: {
            result = $0
        }).disposed(by: disposeBag)
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(result)
        // Trigger action
        let action = alertController.actions.first!
        typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
        let block = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        // Check result
        XCTAssertNil(result)
    }

}
