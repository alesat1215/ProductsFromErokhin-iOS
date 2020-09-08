//
//  Products.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Product
struct Product {
    let name: String
    let consist: String
    let img: String
    let price: Int
    let inStart: Bool
    let inStart2: Bool
}

extension Product: Codable {
    enum CodingKeys: String, CodingKey {
        case name, consist, img, price, inStart, inStart2
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        consist = (try? values.decode(String.self, forKey: .consist)) ?? ""
        img = (try? values.decode(String.self, forKey: .img)) ?? ""
        price = (try? values.decode(Int.self, forKey: .price)) ?? 0
        inStart = (try? values.decode(Bool.self, forKey: .inStart)) ?? false
        inStart2 = (try? values.decode(Bool.self, forKey: .inStart)) ?? false
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
    /** Get NSManagedObject for Group */
    func managedObject(context: NSManagedObjectContext, groupOrder: Int, productOrder: inout Int) -> NSManagedObject {
        // Create entity for group & set values
        let groupInfo = NSEntityDescription.insertNewObject(forEntityName: "GroupInfo", into: context)
        (groupInfo as? GroupInfo)?.update(from: self, order: groupOrder)
        // Create entitys for products & set values
        let productsInfo = products.map { product -> NSManagedObject in
            let productInfo = NSEntityDescription.insertNewObject(forEntityName: "ProductInfo", into: context)
            (productInfo as? ProductInfo)?.update(from: product, order: productOrder)
            productOrder += 1
            return productInfo
        }
        // Add products to relationship
        (groupInfo as? GroupInfo)?.addToProducts(NSSet(array: productsInfo))
        // Return result
        return groupInfo
    }
}
