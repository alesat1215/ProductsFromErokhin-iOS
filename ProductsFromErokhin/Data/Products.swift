//
//  Products.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

struct Product {
    var group = ""
    var name = ""
    var consist = ""
    var img = ""
    var price = 0
    var inStart = false
    var inStart2 = false
}

struct Group {
    var name = ""
    var products = [Product]()
}

extension Group {
    /** - Returns: products with group name */
    func productsWithGroup() -> [Product] {
        products.map {
            var product = $0
            product.group = name
            return product
        }
    }
}
