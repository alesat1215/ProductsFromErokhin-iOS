//
//  AboutProductsViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 13.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class AboutProductsViewControllerTests: XCTestCase {
    private var controller: AboutProductsViewController!
    private var viewModel: AboutProductsViewModelMock!
    private var navigationController: UINavigationController!
    // Outlets
    private var aboutProducts: CollectionViewMock!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AboutProductsViewController")
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        // Set viewModel & products
        aboutProducts = CollectionViewMock()
        viewModel = AboutProductsViewModelMock()
        controller.viewModel = viewModel
        controller.aboutProducts = aboutProducts
        
        controller.viewDidLoad()
    }
    
    func testBindAboutProducts() {
        // Error. Show message
        XCTAssertNil(aboutProducts.dataSource)
        XCTAssertNil(controller.presentedViewController)
        viewModel.aboutProductsResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(aboutProducts.dataSource)
        XCTAssertFalse(aboutProducts.isReload)
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
        XCTAssertNil(aboutProducts.dataSource)
        XCTAssertFalse(aboutProducts.isReload)
        
        // Success
        let dataSource = CoreDataSourceCollectionViewMock(fetchRequest: AboutProducts.fetchRequestWithSort())
        viewModel.aboutProductsResult.accept(Event.next(dataSource))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(aboutProducts.dataSource as! CoreDataSourceCollectionViewMock, dataSource)
        XCTAssertTrue(aboutProducts.isReload)
    }

}
