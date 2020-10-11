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
    private var tutorialController: TutorialViewController!
    private var dataSource: PagesDataSourceMock<Instruction>!
    private var instruction: Instruction!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "InstructionViewController")
        instruction = Instruction(context: context)
        instruction.title = "title"
        instruction.img_path = "img_path"
        instruction.text = "text"
        controller.bind(model: instruction)
        
        dataSource = PagesDataSourceMock()
        dataSource.isLastPageResult = true
        tutorialController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TutorialViewController")
        tutorialController.dataSource = dataSource
        tutorialController.setViewControllers([controller], direction: .forward, animated: true)
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [tutorialController]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
    }

    override func tearDownWithError() throws {
        try Instruction.clearEntity(context: context)
    }
    
    func testBindInstruction() {
        // Last page. OK is available. Instruction with image. Image available
        XCTAssertEqual(controller._title.text, instruction.title)
        XCTAssertEqual(controller.text.text, instruction.text)
        XCTAssertFalse(controller.image.isHidden)
        XCTAssertFalse(controller.ok.isHidden)
        // Not last page. OK is unavailable.
        dataSource.isLastPageResult = false
        controller.viewDidLoad()
        XCTAssertTrue(controller.ok.isHidden)
        // Instruction without image. Image unavailable
        controller.model?.img_path = nil
        controller.viewDidLoad()
        XCTAssertTrue(controller.image.isHidden)
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
