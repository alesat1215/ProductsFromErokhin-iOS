//
//  NSManagedObjectContext+Rx.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

extension Reactive where Base: NSManagedObjectContext {
    /**
    Executes a fetch request and returns as an `Observable` the CoreDataSource object for binding to DataSource protocol for collection view.
    - parameter fetchRequest: an instance of `NSFetchRequest` to describe the search criteria used to retrieve data from a persistent store
    - parameter sectionNameKeyPath: the key path on the fetched objects used to determine the section they belong to; defaults to `nil`
    - parameter cacheName: the name of the file used to cache section information; defaults to `nil`
    - returns: An `Observable` CoreDataSource that can be bound to a collection view.
    */
    func coreDataSource<T: NSManagedObject>(
        cellId: String,
        fetchRequest: NSFetchRequest<T>,
        sectionNameKeyPath: String? = nil,
        cacheName: String? = nil
    ) -> Observable<CoreDataSourceCollectionView<T>> {
        
        Observable.create {
            let coreDataSource = CoreDataSourceCollectionView(
                observer: $0,
                cellId: cellId,
                fetchRequest: fetchRequest,
                managedObjectContext: self.base,
                sectionNameKeyPath: sectionNameKeyPath,
                cacheName: cacheName
            )
            return Disposables.create {
                coreDataSource.dispose()
            }
        }
    }
    /**
    Executes a fetch request and returns as an `Observable` the CoreDataSource object for binding to DataSource protocol for table view.
    - parameter fetchRequest: an instance of `NSFetchRequest` to describe the search criteria used to retrieve data from a persistent store
    - parameter sectionNameKeyPath: the key path on the fetched objects used to determine the section they belong to; defaults to `nil`
    - parameter cacheName: the name of the file used to cache section information; defaults to `nil`
    - returns: An `Observable` CoreDataSource that can be bound to a collection view.
    */
    func coreDataSource<T: NSManagedObject>(
        cellId: String,
        fetchRequest: NSFetchRequest<T>,
        sectionNameKeyPath: String? = nil,
        cacheName: String? = nil
    ) -> Observable<CoreDataSourceTableView<T>> {
        
        Observable.create {
            let coreDataSource = CoreDataSourceTableView(
                observer: $0,
                cellId: cellId,
                fetchRequest: fetchRequest,
                managedObjectContext: self.base,
                sectionNameKeyPath: sectionNameKeyPath,
                cacheName: cacheName
            )
            return Disposables.create {
                coreDataSource.dispose()
            }
        }
    }
}
