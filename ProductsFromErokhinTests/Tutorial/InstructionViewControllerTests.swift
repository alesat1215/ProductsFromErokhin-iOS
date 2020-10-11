//
//  InstructionViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class InstructionViewControllerTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var controller: InstructionViewController!
    private var navigationController: UINavigationController!
    private var instruction: Instruction!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "InstructionViewController")
        instruction = Instruction(context: context)
        instruction.title = "title"
        instruction.img_path = "img_path"
        instruction.text = "text"
        controller.bind(model: instruction)
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBindInstruction() {
        XCTAssertEqual(controller._title.text, instruction.title)
        XCTAssertEqual(controller.text.text, instruction.text)
        XCTAssertFalse(controller.image.isHidden)
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
