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
    private var view: ModernView!

    override func setUpWithError() throws {
        view = ModernView()
    }
    
    func testFirstColor() {
        let layer = view.layer as! CAGradientLayer
        XCTAssertNil(layer.colors)
        view.firstColor = UIColor.red
        XCTAssertEqual(layer.colors?.first as! CGColor, view.firstColor.cgColor)
        XCTAssertEqual(layer.colors?.last as! CGColor, view.secondColor.cgColor)
    }
    
    func testSecondColor() {
        let layer = view.layer as! CAGradientLayer
        XCTAssertNil(layer.colors)
        view.secondColor = UIColor.red
        XCTAssertEqual(layer.colors?.first as! CGColor, view.firstColor.cgColor)
        XCTAssertEqual(layer.colors?.last as! CGColor, view.secondColor.cgColor)
    }
    
    func testIsHorizontal() {
        let layer = view.layer as! CAGradientLayer
        XCTAssertNil(layer.colors)
        XCTAssertEqual(layer.startPoint, CGPoint(x: 0.5, y: 0.0))
        XCTAssertEqual(layer.endPoint, CGPoint(x: 0.5, y: 1.0))
        // Horizontal
        view.isHorizontal = true
        XCTAssertEqual(layer.colors?.first as! CGColor, view.firstColor.cgColor)
        XCTAssertEqual(layer.colors?.last as! CGColor, view.secondColor.cgColor)
        XCTAssertNotEqual(layer.startPoint, CGPoint(x: 0.5, y: 0.0))
        XCTAssertNotEqual(layer.endPoint, CGPoint(x: 0.5, y: 1.0))
        // Vertical
        layer.colors = nil
        view.isHorizontal = false
        XCTAssertEqual(layer.colors?.first as! CGColor, view.firstColor.cgColor)
        XCTAssertEqual(layer.colors?.last as! CGColor, view.secondColor.cgColor)
        XCTAssertEqual(layer.startPoint, CGPoint(x: 0.5, y: 0.0))
        XCTAssertEqual(layer.endPoint, CGPoint(x: 0.5, y: 1.0))
    }
    
    func testLayerClass() {
        XCTAssertTrue(ModernView.layerClass is CAGradientLayer.Type)
    }

}
