//
//  ContactsViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class ContactsViewControllerTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var contacts: SellerContacts!
    private var controller: ContactsViewController!
    private var viewModel: ContactsViewModelMock!
    private var navigationController: UINavigationController!

    override func setUpWithError() throws {
        contacts = SellerContacts(context: context)
        contacts.phone = "phone"
        contacts.address = "address"
        
        viewModel = ContactsViewModelMock()
        
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ContactsViewController")
        controller.viewModel = viewModel
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
    }

    override func tearDownWithError() throws {
        try SellerContacts.clearEntity(context: context)
    }
    
    func testBindContacts() {
        // Error. Show message
        XCTAssertNotEqual(controller.phone.text, contacts.phone)
        XCTAssertNotEqual(controller.address.text, contacts.address)
        viewModel.contactsResult.accept(Event.error(AppError.unknown))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(controller.presentedViewController)
        let alertController = controller.presentedViewController as! UIAlertController
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.style, .default)
        XCTAssertEqual(alertController.actions.first?.title, "OK")
        XCTAssertNotEqual(controller.phone.text, contacts.phone)
        XCTAssertNotEqual(controller.address.text, contacts.address)
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
        XCTAssertNotEqual(controller.phone.text, contacts.phone)
        XCTAssertNotEqual(controller.address.text, contacts.address)
        
        // Empty array of contats
        viewModel.contactsResult.accept(Event.next([]))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertNotEqual(controller.phone.text, contacts.phone)
        XCTAssertNotEqual(controller.address.text, contacts.address)
        
        // Success
        viewModel.contactsResult.accept(Event.next([contacts]))
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(controller.presentedViewController)
        XCTAssertEqual(controller.phone.text, contacts.phone)
        XCTAssertEqual(controller.address.text, contacts.address)
    }
    
    func testSetupCallAction() {
        viewModel.contactsResult.accept(Event.next([contacts]))
        
        controller.call.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModel.isCall)
        XCTAssertEqual(viewModel.phoneResult, "telprompt://\(contacts.phone!)")
    }

}
