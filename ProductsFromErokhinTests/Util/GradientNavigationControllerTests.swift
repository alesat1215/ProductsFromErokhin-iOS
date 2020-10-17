//
//  GradientNavigationControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 17.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class GradientNavigationControllerTests: XCTestCase {
    private var controller: GradientNavigationController!

    override func setUpWithError() throws {
        controller = GradientNavigationController()
    }
    
    func testFirstColor() {
        XCTAssertNil(controller.navigationBar.backgroundImage(for: .default))
        controller.firstColor = UIColor.red
        XCTAssertNotNil(controller.navigationBar.backgroundImage(for: .default))
    }
    
    func testSecondColor() {
        XCTAssertNil(controller.navigationBar.backgroundImage(for: .default))
        controller.secondColor = UIColor.red
        XCTAssertNotNil(controller.navigationBar.backgroundImage(for: .default))
    }
    
    func testIsHorizontal() {
        XCTAssertNil(controller.navigationBar.backgroundImage(for: .default))
        controller.isHorizontal = false
        XCTAssertNotNil(controller.navigationBar.backgroundImage(for: .default))
        controller.navigationBar.setBackgroundImage(nil, for: .default)
        XCTAssertNil(controller.navigationBar.backgroundImage(for: .default))
        controller.isHorizontal = true
        XCTAssertNotNil(controller.navigationBar.backgroundImage(for: .default))
    }

}
