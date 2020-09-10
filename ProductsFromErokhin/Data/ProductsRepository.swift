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
class ProductsRepository {
    private let updater: DatabaseUpdater! // di
    private let context: NSManagedObjectContext!// di
    
    init(updater: DatabaseUpdater?, context: NSManagedObjectContext?) {
        self.updater = updater
        self.context = context
    }
    /** Fetch observable groups array from database only once */
    private lazy var _groups = context.rx
        .entities(fetchRequest: Group.fetchRequestWithSort()).materialize()
    /** Fetch observable products array from database only once */
    private lazy var _products = context.rx
        .entities(fetchRequest: Product.fetchRequestWithSort()).materialize()

    /**
     Get groups from database & update it if needed
     - returns: Observable array with groups
     */
    func groups() -> Observable<Event<[Group]>> {
        Observable.merge([_groups, updater.sync()])
    }
    /**
     Get products from database & update it if needed
     - returns: Observable array with products
     */
    func products() -> Observable<Event<[Product]>> {
        Observable.merge([_products, updater.sync()])
    }
    
}
