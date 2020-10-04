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
    
    var predicate: NSPredicate?
    var keys: [CNKeyDescriptor]?
    var unifiedContactsResult = [CNContact]()
    var unifiedContactsResultThrow: Error?
    override func unifiedContacts(matching predicate: NSPredicate, keysToFetch keys: [CNKeyDescriptor]) throws -> [CNContact] {
        self.predicate = predicate
        self.keys = keys
        guard let error = unifiedContactsResultThrow else {
            return unifiedContactsResult
        }
        throw error
    }
}
