//
//  AboutProducts.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 12.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

extension AboutProducts: Ordered {
    /** Request with section & order sort */
    static func fetchRequestWithSort(
        sortDescriptors: [NSSortDescriptor] = [
            NSSortDescriptor(key: #keyPath(AboutProducts.section), ascending: true),
            NSSortDescriptor(key: #keyPath(AboutProducts.order), ascending: true)
        ],
        predicate: NSPredicate?) -> NSFetchRequest<AboutProducts> {
        let fetchRequest: NSFetchRequest<AboutProducts> = self.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    /** Set values from InstructionRemote with order */
    func update(from remote: AboutProductsRemote, order: Int) {
        self.order = Int16(order)
        title = remote.title
        text = remote.text
        img = remote.img
        section = remote.img.isEmpty ? 0 : 1
    }
}
