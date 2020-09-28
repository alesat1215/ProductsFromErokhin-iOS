//
//  CoreDataSourceCollectionViewMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
@testable import ProductsFromErokhin

class CoreDataSourceCollectionViewMock<T: NSFetchRequestResult>: CoreDataSourceCollectionView<T> {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(fetchRequest: NSFetchRequest<T>) {
        super.init(observer: AnyObserver(eventHandler: {_ in }), cellId: "", fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    var isSelected = false
    let selectResult = Result<Void, Error>.success(())
    override func select(indexPath: IndexPath) -> Result<Void, Error> where T == Group {
        isSelected.toggle()
        return selectResult
    }
    
    var objectResult: T?
    override func object(at indexPath: IndexPath) -> T? {
        objectResult
    }
    
    var indexPathResult: IndexPath?
    override func indexPath(for object: T) -> IndexPath? {
        indexPathResult
    }
}


