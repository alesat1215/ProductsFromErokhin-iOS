//
//  CoreDataSourceMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
@testable import ProductsFromErokhin

class CoreDataSourceMock<T: NSFetchRequestResult>: CoreDataSourceCollectionView<T> {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(fetchRequest: NSFetchRequest<T>) {
        super.init(observer: AnyObserver(eventHandler: {_ in }), cellId: "", fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
}
