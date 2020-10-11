//
//  PagesDataSourceTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class PagesDataSourceTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var controller: TutorialViewController!
    private var navigationController: UINavigationController!
    private var instructions = [Instruction]()
    private var dataSource: PagesDataSource<Instruction>!

    override func setUpWithError() throws {
        instructions = ["title", "title1", "title2"].enumerated().map {
            let instruction = Instruction(context: context)
            instruction.order = Int16($0.offset)
            instruction.title = $0.element
            return instruction
        }
        
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TutorialViewController")
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        controller.viewDidLoad()
        
        dataSource = PagesDataSource(data: instructions, storyboardId: "InstructionViewController")
    }

    override func tearDownWithError() throws {
        try Instruction.clearEntity(context: context)
    }
    
    func testBind() {
        XCTAssertEqual(dataSource.bind(to: nil), dataSource)
        
        XCTAssertNil(controller.dataSource)
        XCTAssertEqual(dataSource.bind(to: controller), dataSource)
        XCTAssertEqual(controller.dataSource as? PagesDataSource, dataSource)
        XCTAssertFalse(controller.viewControllers?.isEmpty ?? true)
        XCTAssertEqual((controller.viewControllers?.first as? BindablePage)?.model, instructions.first)
    }
    
    func testIsLastPage() {
        _ = dataSource.bind(to: controller)
        let page1 = controller.viewControllers!.first!
        let page2 = dataSource.pageViewController(controller, viewControllerAfter: page1)!
        let page3 = dataSource.pageViewController(controller, viewControllerAfter: page2)!
        XCTAssertFalse(dataSource.isLastPage(page1))
        XCTAssertFalse(dataSource.isLastPage(page2))
        XCTAssertTrue(dataSource.isLastPage(page3))
    }
    
    //MARK: - DataSource
    
    func testViewControllerBefore() {
        _ = dataSource.bind(to: controller)
        
        let page1 = controller.viewControllers!.first!
        let page2 = dataSource.pageViewController(controller, viewControllerAfter: page1)!
        let page3 = dataSource.pageViewController(controller, viewControllerAfter: page2)!
        
        XCTAssertEqual(dataSource.pageViewController(controller, viewControllerBefore: page3), page2)
        XCTAssertEqual(dataSource.pageViewController(controller, viewControllerBefore: page2), page1)
        XCTAssertNil(dataSource.pageViewController(controller, viewControllerBefore: page1))
    }
    
    func testViewControllerAfter() {
        _ = dataSource.bind(to: controller)
        let page1 = controller.viewControllers!.first!
        let page2 = dataSource.pageViewController(controller, viewControllerAfter: page1)
        XCTAssertNotNil(page2)
        let page3 = dataSource.pageViewController(controller, viewControllerAfter: page2!)
        XCTAssertNotNil(page3)
        XCTAssertNil(dataSource.pageViewController(controller, viewControllerAfter: page3!))
    }
    
    func testPresentationCount() {
        _ = dataSource.bind(to: controller)
        XCTAssertEqual(dataSource.presentationCount(for: controller), instructions.count)
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
