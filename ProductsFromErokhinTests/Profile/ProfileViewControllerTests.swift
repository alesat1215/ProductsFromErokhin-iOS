//
//  ProfileViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import IQKeyboardManagerSwift
@testable import ProductsFromErokhin

class ProfileViewControllerTests: XCTestCase {
    
    private var controller: ProfileViewController!
    private var viewModel: ProfileViewModelMock!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var navigationController: UINavigationController!
    // Outlets
    private var _name: UITextField!
    private var phone: UITextField!
    private var address: UITextField!
    private var save: UIButton!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileViewController")
        
        // Set views
        _name = UITextField()
        phone = UITextField()
        address = UITextField()
        save = UIButton()
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        // Set viewModel & outlets
        viewModel = ProfileViewModelMock()
        controller.viewModel = viewModel
        controller.name = _name
        controller.phone = phone
        controller.address = address
        controller.save = save
        
        controller.view.addSubview(controller.name)
        controller.view.addSubview(controller.phone)
        controller.view.addSubview(controller.address)
        
        controller.viewDidLoad()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
