//
//  RemoteConfig+RxTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 06.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import FirebaseRemoteConfig
@testable import ProductsFromErokhin

class RemoteConfig_RxTests: XCTestCase {
    
    func testFetchAndActivate() {
        let disposeBag = DisposeBag()
        let remoteConfig = RemoteConfigMock()
        var result: (status: RemoteConfigFetchAndActivateStatus, error: Error?)?
        remoteConfig.rx.fetchAndActivate()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        
        // Error. Not completed
        remoteConfig.completionHandler?(RemoteConfigFetchAndActivateStatus.error, AppError.unknown)
        XCTAssertEqual(result?.status, RemoteConfigFetchAndActivateStatus.error)
        XCTAssertEqual(result?.error?.localizedDescription, AppError.unknown.localizedDescription)
        
        // Not error. Completed
        remoteConfig.completionHandler?(RemoteConfigFetchAndActivateStatus.successFetchedFromRemote, nil)
        XCTAssertEqual(result?.status, RemoteConfigFetchAndActivateStatus.successFetchedFromRemote)
        XCTAssertNil(result?.error)
        // Result not changed, because sequense is completed
        remoteConfig.completionHandler?(RemoteConfigFetchAndActivateStatus.successUsingPreFetchedData, nil)
        XCTAssertEqual(result?.status, RemoteConfigFetchAndActivateStatus.successFetchedFromRemote)
    }

}
