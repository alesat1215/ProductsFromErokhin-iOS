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

class ProductsRepository {
    private let updater: DatabaseUpdater! // di
    private let context: NSManagedObjectContext!// di
    
    init(updater: DatabaseUpdater?, context: NSManagedObjectContext?) {
        self.updater = updater
        self.context = context
    }
    
    private lazy var _products = context.rx
        .entities(fetchRequest: Product.fetchRequestWithSort()).materialize()
    private lazy var _groups = context.rx
        .entities(fetchRequest: Group.fetchRequestWithSort()).materialize()
    
    func groups() -> Observable<Event<[Group]>> {
        Observable.merge([_groups, updater.sync()])
    }
    
    func products() -> Observable<Event<[Product]>> {
        Observable.merge([_products, updater.sync()])
    }
    
}
