//
//  CoreDataSourceTableViewMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 28.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
@testable import ProductsFromErokhin

class CoreDataSourceTableViewMock<T: NSFetchRequestResult>: CoreDataSourceTableView<T> {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(fetchRequest: NSFetchRequest<T>) {
        super.init(observer: AnyObserver(eventHandler: {_ in }), cellId: "", fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    var indexPathResult: IndexPath?
    override func productPositionForGroup(group: Group) -> IndexPath? where T == Product {
        indexPathResult
    }
    
    var objectResult: T?
    override func object(at indexPath: IndexPath) -> T? {
        objectResult
    }
}
