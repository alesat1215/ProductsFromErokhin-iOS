//
//  JSONDecoderMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class JSONDecoderMockTests: XCTestCase {
    
    func testDecode() {
        let decoder = JSONDecoderMock()
        
        XCTAssertTrue(try decoder.decode([GroupRemote].self, from: Data()) is [GroupRemote])
        XCTAssertTrue(try decoder.decode(TitlesRemote.self, from: Data()) is TitlesRemote)
    }

}
