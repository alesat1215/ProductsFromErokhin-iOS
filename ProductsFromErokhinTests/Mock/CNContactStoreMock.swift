//
//  CNContactStoreMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 03.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import Contacts

class CNContactStoreMock: CNContactStore {
    var completionHandler: ((Bool, Error?) -> Void)?
    override func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void) {
        self.completionHandler = completionHandler
    }
}
