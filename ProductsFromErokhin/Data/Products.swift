//
//  Products.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

// MARK: - Product
struct Product {
    let group: String
    let name: String
    let consist: String
    let img: String
    let price: Int
    let inStart: Bool
    let inStart2: Bool
}

extension Product: Codable {
    enum CodingKeys: String, CodingKey {
        case group, name, consist, img, price, inStart, inStart2
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        group = (try? values.decode(String.self, forKey: .group)) ?? ""
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        consist = (try? values.decode(String.self, forKey: .consist)) ?? ""
        img = (try? values.decode(String.self, forKey: .img)) ?? ""
        price = (try? values.decode(Int.self, forKey: .price)) ?? 0
        inStart = (try? values.decode(Bool.self, forKey: .inStart)) ?? false
        inStart2 = (try? values.decode(Bool.self, forKey: .inStart)) ?? false
    }
}

extension Product {
    /** For init product with group name */
    init(group: String, product: Product) {
        self.group = group
        name = product.name
        consist = product.consist
        img = product.img
        price = product.price
        inStart = product.inStart
        inStart2 = product.inStart2
    }
}

// MARK: - Group
struct Group {
    var name = ""
    var products = [Product]()
}

extension Group: Codable {
    enum CodingKeys: String, CodingKey {
        case name, products
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        products = (try? values.decode([Product].self, forKey: .products)) ?? []
    }
}

extension Group {
    /** - Returns: products with group name */
    func productsWithGroup() -> [Product] {
        products.map {
            Product(group: name, product: $0)
        }
    }
}
