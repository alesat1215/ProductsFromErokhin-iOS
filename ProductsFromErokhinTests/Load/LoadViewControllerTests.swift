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
    private let viewModel = LoadViewModelMock()

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadViewController") as! LoadViewController
        controller.viewModel = viewModel
        // For segue
        let window = UIWindow()
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    func testLoadDataAuthError() {
        controller.viewDidLoad()
        let exp = expectation(description: "Wait 3 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 3)
        XCTAssertNil(controller.presentedViewController)
    }
    
    func testLoadDataAuthSuccess() {
        viewModel.authResult = Event.next(())
        controller.viewDidLoad()
        XCTAssertNil(controller.presentedViewController)
        // Load error
        viewModel.loadCompleteResult.accept(Event.error(AppError.unknown))
        var exp = expectation(description: "Wait 3 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 3)
        XCTAssertNil(controller.presentedViewController)
        // Load empty
        viewModel.loadCompleteResult.accept(Event.next(false))
        exp = expectation(description: "Wait 3 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 3)
        XCTAssertNil(controller.presentedViewController)
        // Load success
        viewModel.loadCompleteResult.accept(Event.next(true))
        exp = expectation(description: "Wait 3 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 3)
        XCTAssertNotNil(controller.presentedViewController)
    }

}
