//
//  TutorialViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class TutorialViewControllerTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var controller: TutorialViewController!
    private var navigationController: UINavigationController!
    private var viewModel: TutorialViewModelMock!
    private var instruction: Instruction!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TutorialViewController")
        viewModel = TutorialViewModelMock()
        controller.viewModel = viewModel
        
        instruction = Instruction(context: context)
        instruction.title = "title"
        instruction.img_path = "img_path"
        instruction.text = "text"
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
    }

    override func tearDownWithError() throws {
        try Instruction.clearEntity(context: context)
    }
    
    func testBindDataSource() {
        XCTAssertNil(controller.dataSource)
        XCTAssertNil(controller.viewControllers?.first)
        
        // Error. Show message
        XCTAssertNil(controller.presentedViewController)
        viewModel.instructionsResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(controller.dataSource)
        XCTAssertNil(controller.viewControllers?.first)
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
        XCTAssertNil(controller.dataSource)
        XCTAssertNil(controller.viewControllers?.first)
        
        // Success. Bind dataSource
        viewModel.instructionsResult.accept(Event.next([instruction]))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertNotNil(controller.dataSource)
        XCTAssertNotNil(controller.viewControllers?.first)
    }

}
