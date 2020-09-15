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
        addToInCart(NSSet(object: productInCart))
        // Save & return result
        return save(context: context)
    }
    /** Del product from cart */
    func delFromCart() -> Result<Void, Error> {
        // Check context
        guard let context = managedObjectContext else {
            return .failure(AppError.context)
        }
        // Get `ProductInCart` entity from relationship & delete
        guard let productInCart = inCart?.anyObject() else {
            print("Not del from cart. Cart is empty")
            return .success(())
        }
        removeFromInCart(NSSet(object: productInCart))
        // Save & return result
        return save(context: context)
    }
    /** Save changes in context */
    private func save(context: NSManagedObjectContext) -> Result<Void, Error> {
        // Check the need to save
        if !context.hasChanges {
            print("Nothing to save. Context hash't changes")
            return .success(())
        }
        // Save changes
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
