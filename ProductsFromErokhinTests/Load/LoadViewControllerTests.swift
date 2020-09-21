//
//  LoadViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import Swinject
import SwinjectStoryboard
@testable import ProductsFromErokhin

class LoadViewControllerTests: XCTestCase {
    
    private var controller: LoadViewController!
    private let viewModel = LoadViewModelMock()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        SwinjectStoryboard.defaultContainer.register(LoadViewModel.self) { _ in
//            self.viewModel
//        }
        
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadViewController") as! LoadViewController
        controller.viewModel = viewModel
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
//        XCTAssertTrue(ProcessInfo.processInfo.arguments.contains("test"))
//        XCTAssertNotNil(ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"])
    }
    
    func testLoadData() throws {
        // Auth error
        XCTAssertNil(controller.presentedViewController)
        viewModel.authResult.accept(Event.error(AppError.unknown))
        XCTAssertNil(controller.presentedViewController)
        // Auth succes, load error
        viewModel.authResult.accept(Event.next(()))
        XCTAssertNil(controller.presentedViewController)
        // Auth succes, load empty
        viewModel.loadCompleteResult = Event.next(false)
        viewModel.authResult.accept(Event.next(()))
        XCTAssertNil(controller.presentedViewController)
        // Auth succes, load success
        viewModel.loadCompleteResult = Event.next(true)
        viewModel.authResult.accept(Event.next(()))
        let exp = expectation(description: "Wait 3 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 3)
        if result == .timedOut {
            XCTAssertNotNil(controller.presentedViewController)
        } else {
            XCTFail("Delay interrupted")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
