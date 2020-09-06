//
//  ProductInfo+Extension.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 05.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

extension ProductInfo {
    /** Set values from Product with order */
    func update(from remote: Product, order: Int) {
        self.order = Int16(order)
        consist = remote.consist
        img = remote.img
        inStart = remote.inStart
        inStart2 = remote.inStart2
        name = remote.name
        price = Int16(remote.price)
    }
}

extension ProductInfo: Ordered {
    typealias T = ProductInfo
}
