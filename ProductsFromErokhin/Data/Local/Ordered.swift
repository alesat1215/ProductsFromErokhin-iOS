//
//  Ordered.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 06.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

protocol Ordered {
    associatedtype T: NSFetchRequestResult
    var order: Int16 { get set }
    static func fetchRequestWithSort(
        _ sortDescriptors: [NSSortDescriptor]) -> NSFetchRequest<T>
    static func fetchRequest() -> NSFetchRequest<T>
}

extension Ordered {
    /** Fetch request fith default sort by order attribute */
    static func fetchRequestWithSort(
        _ sortDescriptors: [NSSortDescriptor] =
        [NSSortDescriptor(key: "order", ascending: true)]
    ) -> NSFetchRequest<T> {
        let fetchRequest: NSFetchRequest<T> = self.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }
}
