//
//  ContextMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

class ContextMock: NSManagedObjectContext {
    init() {
        super.init(concurrencyType: .mainQueueConcurrencyType)
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)!
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        persistentStoreCoordinator = storeCoordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isSaving = false
    override func save() throws {
        isSaving.toggle()
    }
    var isInsert = false
    override func insert(_ object: NSManagedObject) {
        isInsert = true
    }
    
    override var hasChanges: Bool { true }
    
    var fetchResult = [Any]()
    var isFetch = false
    override func fetch(_ request: NSFetchRequest<NSFetchRequestResult>) throws -> [Any] {
        isFetch.toggle()
        return fetchResult
    }
}
