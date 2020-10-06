//
//  ProductsRemote.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Product
struct ProductRemote {
    let name: String
    let consist: String
    let img: String
    let price: Int
    let inStart: Bool
    let inStart2: Bool
}

extension ProductRemote: Codable, Equatable {
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
        inStart2 = (try? values.decode(Bool.self, forKey: .inStart2)) ?? false
    }
}

// MARK: - Group
struct GroupRemote {
    let name: String
    let products: [ProductRemote]
}

extension GroupRemote: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case name, products
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        products = (try? values.decode([ProductRemote].self, forKey: .products)) ?? []
    }
}

extension GroupRemote {
    /** Get NSManagedObject for Group */
    func managedObject(context: NSManagedObjectContext, groupOrder: Int, productOrder: inout Int, allInCart: [ProductInCart]) -> NSManagedObject {
        // Create entity for group & set values
        let group = NSEntityDescription.insertNewObject(forEntityName: "Group", into: context)
        (group as? Group)?.update(from: self, order: groupOrder)
        // Create entitys for products, set values & relationship by name with products in cart
        let productsMO = products.map { productRemote -> NSManagedObject in
            let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
            (product as? Product)?.update(
                from: productRemote,
                order: productOrder,
                inCart: allInCart.filter { $0.name == productRemote.name }
            )
            productOrder += 1
            return product
        }
        // Add products to relationship
        (group as? Group)?.addToProducts(NSSet(array: productsMO))
        // Return result
        return group
    }
}
