//
//  UserDefaultsMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

class UserDefaultsMock: UserDefaults {
    var isBool = false
    var boolResult = false
    override func bool(forKey defaultName: String) -> Bool {
        isBool.toggle()
        return boolResult
    }
    
    var isSet = false
    var setResult: Bool?
    override func set(_ value: Bool, forKey defaultName: String) {
        setResult = value
        isSet.toggle()
    }
}
