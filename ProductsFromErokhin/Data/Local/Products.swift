//
//  Products.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 08.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Product
extension Product: Ordered {
    /** Set values from ProductRemote with order */
    func update(from remote: ProductRemote, order: Int) {
        self.order = Int16(order)
        consist = remote.consist
        img = remote.img
        inStart = remote.inStart
        inStart2 = remote.inStart2
        name = remote.name
        price = Int16(remote.price)
    }
    
}

extension Product {
    /** Add product to cart */
    func addToCart() -> Result<Void, Error> {
        // Check context
        guard let context = managedObjectContext else {
            return .failure(AppError.context)
        }
        // Create `ProductInCart` entity & add to relationship
        let productInCart = NSEntityDescription.insertNewObject(forEntityName: "ProductInCart", into: context)
        self.addToInCart(NSSet(object: productInCart))
        // Save & return result
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Group
extension Group: Ordered {
    /** Set values from GroupRemote with order */
    func update(from remote: GroupRemote, order: Int) {
        self.order = Int16(order)
        name = remote.name
    }
}
