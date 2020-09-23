//
//  ProductsRepository.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData

/** Repository for groups & products */
class AppRepository {
    private let updater: DatabaseUpdater! // di
    private let context: NSManagedObjectContext!// di
    
    init(updater: DatabaseUpdater?, context: NSManagedObjectContext?) {
        self.updater = updater
        self.context = context
    }
    /**
     Get groups from database & update it if needed
     - returns: Observable array with groups
     */
    func groups() -> Observable<Event<CoreDataSourceCollectionView<Group>>> {
        Observable.merge([
            context.rx.coreDataSource(
                cellId: "group",
                fetchRequest: Group.fetchRequestWithSort()
            ).materialize(),
            updater.sync()
        ])
    }
    /**
    Get titles from database & update it if needed
    - returns: Observable array with products
    */
    func titles() -> Observable<Event<[Titles]>> {
        Observable.merge([
            context.rx.entities(fetchRequest: Titles.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    /**
    Get products from database & update it if needed
    - returns: Observable dataSource with products for collection view
    */
    func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        Observable.merge([
            context.rx.coreDataSource(
                cellId: cellId,
                fetchRequest: Product.fetchRequestWithSort(predicate: predicate)
            ).materialize(),
            updater.sync()
        ])
    }
    /**
    Get products from database & update it if needed
    - returns: Observable dataSource with products for table view
    */
    func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSourceTableView<Product>>> {
        Observable.merge([
            context.rx.coreDataSource(
                cellId: cellId,
                fetchRequest: Product.fetchRequestWithSort(predicate: predicate)
            ).materialize(),
            updater.sync()
        ])
    }
    
}
