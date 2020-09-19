//
//  RemoteConfigComplectionMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import FirebaseRemoteConfig

class RemoteConfigComplectionMockTests: XCTestCase {
    
    func testResult() {
        let complection = RemoteConfigComplectionMock()
        // _result nil
        XCTAssertNil(try complection.result().toBlocking().first())
        complection._result = (RemoteConfigFetchAndActivateStatus.successFetchedFromRemote, nil)
        XCTAssertEqual(try complection.result().toBlocking().first()?.status, complection._result?.status)
    }

}
