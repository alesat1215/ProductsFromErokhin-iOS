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
    func update(from remote: Product, order: Int) {
        self.order = Int16(order)
        consist = remote.consist
        img = remote.img
        inStart = remote.inStart
        inStart2 = remote.inStart2
        name = remote.name
        price = Int16(remote.price)
    }
    
    /** Fetch request fith default sort by order attribute */
    @nonobjc public class func fetchRequestWithSort(
        _ sortDescriptors: [NSSortDescriptor] =
        [NSSortDescriptor(keyPath: \ProductInfo.order, ascending: true)]
    ) -> NSFetchRequest<ProductInfo> {
        let fetchRequest: NSFetchRequest<ProductInfo> = ProductInfo.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }
}
