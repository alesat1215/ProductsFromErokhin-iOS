//
//  ProfileViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import IQKeyboardManagerSwift
@testable import ProductsFromErokhin

class ProfileViewControllerTests: XCTestCase {
    
    private var controller: ProfileViewController!
    private var viewModel: ProfileViewModelMock!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var navigationController: UINavigationController!

    override func setUpWithError() throws {
        viewModel = ProfileViewModelMock()
        
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileViewController")
        controller.viewModel = viewModel
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
    }
    
    func testBindProfile() {
        XCTAssertTrue(controller.name.text!.isEmpty)
        XCTAssertTrue(controller.phone.text!.isEmpty)
        XCTAssertTrue(controller.address.text!.isEmpty)
        
        let profile = Profile(context: context)
        profile.name = "name"
        profile.phone = "phone"
        profile.address = "address"
        viewModel.profileResult.accept(profile)
        
        XCTAssertEqual(controller.name.text, profile.name)
        XCTAssertEqual(controller.phone.text, profile.phone)
        XCTAssertEqual(controller.address.text, profile.address)
    }
    
    func testSetupKeyboardForProfile() {
        XCTAssertFalse(controller.name.isFirstResponder)
        XCTAssertFalse(controller.phone.isFirstResponder)
        XCTAssertFalse(controller.address.isFirstResponder)
        // name
        controller.name.becomeFirstResponder()
        XCTAssertTrue(controller.name.isFirstResponder)
        XCTAssertFalse(controller.phone.isFirstResponder)
        XCTAssertFalse(controller.address.isFirstResponder)
        controller.name.sendActions(for: .editingDidEndOnExit)
        XCTAssertFalse(controller.name.isFirstResponder)
        XCTAssertTrue(controller.phone.isFirstResponder)
        XCTAssertFalse(controller.address.isFirstResponder)
        // phone
        controller.phone.sendActions(for: .editingDidEndOnExit)
        XCTAssertFalse(controller.name.isFirstResponder)
        XCTAssertFalse(controller.phone.isFirstResponder)
        XCTAssertTrue(controller.address.isFirstResponder)
        // address
        controller.address.sendActions(for: .editingDidEndOnExit)
        XCTAssertFalse(controller.name.isFirstResponder)
        XCTAssertFalse(controller.phone.isFirstResponder)
        XCTAssertFalse(controller.address.isFirstResponder)
    }
    
    func testSetupSaveAction() {
        // Error. Show message
        XCTAssertNil(controller.presentedViewController)
        XCTAssertFalse(viewModel.isUpdateProfile)
        XCTAssertNil(viewModel.updateProfileParamsResult)
        
        controller.save.sendActions(for: .touchUpInside)
        viewModel.updateProfileResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        var alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertEqual(alertController.message, AppError.unknown.localizedDescription)
        XCTAssertTrue(viewModel.isUpdateProfile)
        XCTAssertNotNil(viewModel.updateProfileParamsResult)
    
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
        
        // Success. Show message
        viewModel.isUpdateProfile = false
        viewModel.updateProfileParamsResult = nil
        
        controller.save.sendActions(for: .touchUpInside)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        viewModel.updateProfileResult.accept(Event.next(()))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertEqual(alertController.message, NSLocalizedString("profile", comment: ""))
        XCTAssertTrue(viewModel.isUpdateProfile)
        XCTAssertNotNil(viewModel.updateProfileParamsResult)
    
        // Trigger action OK
        action = alertController.actions.first!
        block = action.value(forKey: "handler")
        blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
        handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        handler(action)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
    }

}
