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
    private let remoteConfigRepository: RemoteConfigRepository // di
    private let context: NSManagedObjectContext// di
    
    init(remoteConfigRepository: RemoteConfigRepository!, context: NSManagedObjectContext!) {
        self.remoteConfigRepository = remoteConfigRepository
        self.context = context
    }
    
    private lazy var _products = context.rx
        .entities(fetchRequest: Product.fetchRequestWithSort()).map {
            Result<[Product], Error>.success($0)
    }
    private lazy var _groups = context.rx
        .entities(fetchRequest: Group.fetchRequestWithSort()).map {
            Result<[Group], Error>.success($0)
    }
    
    func groups() -> Observable<Result<[Group], Error>> {
        Observable.merge([_groups, remoteConfigRepository.fetchAndActivate()])
    }
    
    func products() -> Observable<Result<[Product], Error>> {
        Observable.merge([_products, remoteConfigRepository.fetchAndActivate()])
    }
    
}
