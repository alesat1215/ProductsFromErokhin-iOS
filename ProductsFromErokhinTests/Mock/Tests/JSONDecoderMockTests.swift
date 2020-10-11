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
        
        XCTAssertEqual(try decoder.decode([GroupRemote].self, from: Data()), decoder.groupRemoteResult)
        XCTAssertEqual(try decoder.decode(TitlesRemote.self, from: Data()), decoder.titlesRemoteResult)
        XCTAssertEqual(try decoder.decode(OrderWarningRemote.self, from: Data()), decoder.orderWarningRemoteResult)
        XCTAssertEqual(try decoder.decode(SellerContactsRemote.self, from: Data()), decoder.sellerContactsRemoteResult)
        XCTAssertEqual(try decoder.decode([InstructionRemote].self, from: Data()), decoder.instructionRemoteResult)
        XCTAssertThrowsError(try decoder.decode(String.self, from: Data()))
    }

}
