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
    private let remoteConfigRepository: RemoteConfigRepository! // di
    private let context: NSManagedObjectContext!// di
    
    init(remoteConfigRepository: RemoteConfigRepository?, context: NSManagedObjectContext?) {
        self.remoteConfigRepository = remoteConfigRepository
        self.context = context
    }
    
    private lazy var _products = context.rx
        .entities(fetchRequest: Product.fetchRequestWithSort()).materialize()
    private lazy var _groups = context.rx
        .entities(fetchRequest: Group.fetchRequestWithSort()).materialize()
    
    func groups() -> Observable<Event<[Group]>> {
        Observable.merge([_groups, remoteConfigRepository.fetchAndActivate()])
    }
    
    func products() -> Observable<Event<[Product]>> {
        Observable.merge([_products, remoteConfigRepository.fetchAndActivate()])
    }
    
}
