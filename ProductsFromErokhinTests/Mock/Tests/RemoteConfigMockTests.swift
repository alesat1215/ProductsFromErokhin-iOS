//
//  RemoteConfigMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 06.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class RemoteConfigMockTests: XCTestCase {
    
    private var remoteConfig: RemoteConfigMock!

    override func setUpWithError() throws {
        remoteConfig = RemoteConfigMock()
    }
    
    func testFetchAndActivate() {
        XCTAssertNil(remoteConfig.completionHandler)
        XCTAssertFalse(remoteConfig.isFetchAndActivate)
        remoteConfig.fetchAndActivate(completionHandler: {_,_ in })
        XCTAssertNotNil(remoteConfig.completionHandler)
        XCTAssertTrue(remoteConfig.isFetchAndActivate)
    }

}
