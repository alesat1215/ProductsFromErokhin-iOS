//
//  OrderWarning.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 30.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

extension OrderWarning: Ordered {
    func update(from remote: OrderWarningRemote, order: Int = 0) {
        self.order = Int16(order)
        text = remote.text
        groups = remote.groups
    }
}
