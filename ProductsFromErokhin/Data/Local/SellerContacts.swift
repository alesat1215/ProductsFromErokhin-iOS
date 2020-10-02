//
//  SellerContacts.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 02.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

extension SellerContacts: Ordered {
    func update(from remote: SellerContactsRemote, order: Int = 0) {
        self.order = Int16(order)
        phone = remote.phone
        address = remote.address
    }
}
