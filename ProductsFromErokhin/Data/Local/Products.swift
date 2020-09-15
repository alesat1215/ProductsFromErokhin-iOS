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
        // Save & return result
        return save { context in
            // Create `ProductInCart` entity & add to relationship
            let productInCart = NSEntityDescription.insertNewObject(forEntityName: "ProductInCart", into: context)
            addToInCart(NSSet(object: productInCart))
        }
    }
    /** Del product from cart */
    func delFromCart() -> Result<Void, Error> {
        // Save & return result
        return save { _ in
            // Get `ProductInCart` entity from relationship & delete it
            guard let productInCart = inCart?.anyObject() else {
                print("Not del from cart. Cart is empty")
                return
            }
            removeFromInCart(NSSet(object: productInCart))
        }
    }
    /** Save changes in context */
    private func save(_ block: (_ context: NSManagedObjectContext) -> Void) -> Result<Void, Error> {
        // Check context
        guard let context = managedObjectContext else {
            return .failure(AppError.context)
        }
        // Exec block closure
        block(context)
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
