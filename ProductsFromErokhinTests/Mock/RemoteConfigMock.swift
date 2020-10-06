//
//  RemoteConfigMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 06.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
@testable import ProductsFromErokhin

class RemoteConfigMock: RemoteConfigMethods {
    
    var completionHandler: ((RemoteConfigFetchAndActivateStatus, Error?) -> Void)?
    var isFetchAndActivate = false
    func fetchAndActivate(completionHandler: ((RemoteConfigFetchAndActivateStatus, Error?) -> Void)?) {
        isFetchAndActivate.toggle()
        self.completionHandler = completionHandler
    }
    
    var isSubscript = false
    subscript(key: String) -> RemoteConfigValue {
        isSubscript = true
        return RemoteConfigValue()
    }
    
    
}
