//
//  StartViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class StartViewControllerTests: XCTestCase {
    
    private var controller: StartViewController!
    private var viewModel: StartViewModelMock!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var navigationController: UINavigationController!

    override func setUpWithError() throws {
        viewModel = StartViewModelMock()
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StartViewController")
        controller.viewModel = viewModel
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
    }
    
    func testBindTitles() {
        controller._title.text = nil
        controller.imgTitle.text = nil
        controller.productsTitle.text = nil
        controller.productsTitle2.text = nil
        
        // Error. Show message
        XCTAssertNil(controller.presentedViewController)
        
        viewModel.titlesResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(controller._title.text)
        XCTAssertNil(controller.imgTitle.text)
        XCTAssertNil(controller.productsTitle.text)
        XCTAssertNil(controller.productsTitle2.text)
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
        XCTAssertNil(controller._title.text)
        XCTAssertNil(controller.imgTitle.text)
        XCTAssertNil(controller.productsTitle.text)
        XCTAssertNil(controller.productsTitle2.text)
        
        // Success
        let titles = Titles(context: context)
        titles.title = "title"
        titles.imgTitle = "imgTitle"
        titles.productsTitle = "productsTitle"
        titles.productsTitle2 = "productsTitle2"
        
        viewModel.titlesResult.accept(Event.next([titles]))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        
        XCTAssertEqual(controller._title.text, titles.title)
        XCTAssertEqual(controller.imgTitle.text, titles.imgTitle)
        XCTAssertEqual(controller.productsTitle.text, titles.productsTitle)
        XCTAssertEqual(controller.productsTitle2.text, titles.productsTitle2)
    }
    
    func testBindProducts() {
        let products = CollectionViewMock()
        controller.products = products
        // Error. Show message
        XCTAssertNil(controller.presentedViewController)
        XCTAssertNil(controller.products.dataSource)
        XCTAssertFalse((controller.products as! CollectionViewMock).isReload)
        
        viewModel.productsResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(controller.products.dataSource)
        XCTAssertFalse((controller.products as! CollectionViewMock).isReload)
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
        XCTAssertNil(controller.products.dataSource)
        XCTAssertFalse((controller.products as! CollectionViewMock).isReload)
        
        // Success
        let dataSource = CoreDataSourceCollectionViewMock(fetchRequest: Product.fetchRequestWithSort())
        
        viewModel.productsResult.accept(Event.next(dataSource))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertEqual((controller.products.dataSource as! CoreDataSourceCollectionView), dataSource)
        XCTAssertTrue((controller.products as! CollectionViewMock).isReload)
    }
    
    func testBindProducts2() {
        let products2 = CollectionViewMock()
        controller.products2 = products2
        // Error. Show message
        XCTAssertNil(controller.presentedViewController)
        XCTAssertNil(controller.products2.dataSource)
        XCTAssertFalse((controller.products2 as! CollectionViewMock).isReload)
        
        viewModel.productsResult2.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNil(controller.products2.dataSource)
        XCTAssertFalse((controller.products2 as! CollectionViewMock).isReload)
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
        XCTAssertNil(controller.products2.dataSource)
        XCTAssertFalse((controller.products2 as! CollectionViewMock).isReload)
        
        // Success
        let dataSource = CoreDataSourceCollectionViewMock(fetchRequest: Product.fetchRequestWithSort())
        
        viewModel.productsResult2.accept(Event.next(dataSource))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertEqual((controller.products2.dataSource as! CoreDataSourceCollectionView), dataSource)
        XCTAssertTrue((controller.products2 as! CollectionViewMock).isReload)
    }
    
    func testPrepare() {
        XCTAssertNotNil(controller.products)
        XCTAssertNotNil(controller.products2)
    }
    
    func testAnimation() {
        // Appear/Disappear
        XCTAssertNil(controller.productsTitleContainer.layer.animation(forKey: "productsTitleContainer"))
        controller.viewWillAppear(true)
        XCTAssertNotNil(controller.productsTitleContainer.layer.animation(forKey: "productsTitleContainer"))
        controller.viewWillDisappear(true)
        XCTAssertNil(controller.productsTitleContainer.layer.animation(forKey: "productsTitleContainer"))
        // Foreground/Background
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        XCTAssertNotNil(controller.productsTitleContainer.layer.animation(forKey: "productsTitleContainer"))
        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        XCTAssertNil(controller.productsTitleContainer.layer.animation(forKey: "productsTitleContainer"))
    }

}
