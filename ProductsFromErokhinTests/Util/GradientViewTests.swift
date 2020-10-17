//
//  GradientViewTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 17.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class GradientViewTests: XCTestCase {
    private var view: GradientView!

    override func setUpWithError() throws {
        view = GradientView()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLayerClass() {
        XCTAssertTrue(GradientView.layerClass is CAGradientLayer.Type)
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
