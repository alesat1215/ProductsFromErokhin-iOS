//
//  RemoteConfigComplectionMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift
@testable import ProductsFromErokhin

class RemoteConfigComplectionMock: RemoteConfigComplection {
    var _result: (status: RemoteConfigFetchAndActivateStatus, error: Error?)?
    override func result() -> Observable<(status: RemoteConfigFetchAndActivateStatus, error: Error?)> {
        if let _result = _result {
            return Observable.just(_result)
        }
        return Observable.empty()
    }
}
