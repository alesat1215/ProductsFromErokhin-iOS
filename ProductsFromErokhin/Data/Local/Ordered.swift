//
//  Ordered.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 06.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData
/** NSManagedObject with order attribute, fetch method with sort, clear & update methods from remote data */
protocol Ordered {
    associatedtype T = Self where T: NSManagedObject
    associatedtype C: Codable
    /** Attribute for sort */
    var order: Int16 { get set }
    /** Fetch request fith default sort by order attribute */
    static func fetchRequestWithSort(
        sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> NSFetchRequest<T>
    /** Generated by Core Data */
    static func fetchRequest() -> NSFetchRequest<T>
    /** Specifies all objects for entity that should be removed. Need save changes after */
    static func clearEntity(context: NSManagedObjectContext) throws
    /** Set values from remote data with order */
    func update(from remote: C, order: Int)
}

// MARK: - Implementation
extension Ordered {
    /** Sort by ascending */
    static func fetchRequestWithSort(
        sortDescriptors: [NSSortDescriptor] =
        [NSSortDescriptor(key: "order", ascending: true)],
        predicate: NSPredicate? = nil
    ) -> NSFetchRequest<T> {
        let fetchRequest: NSFetchRequest<T> = self.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}

extension Ordered {
    /** Remove objects for fetchRequestWithSort() result */
    static func clearEntity(context: NSManagedObjectContext) throws {
        // Setup request
        let fetchRequest = self.fetchRequestWithSort()
        fetchRequest.includesPropertyValues = false
        // Get all objects & remove
        let fetchResult = try context.fetch(fetchRequest)
        fetchResult.forEach {
            context.delete($0)
        }
        print("\(fetchResult.count) objects should be removed")
    }
}
