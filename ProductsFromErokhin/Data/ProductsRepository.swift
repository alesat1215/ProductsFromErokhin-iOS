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
    private let remoteConfigRepository: RemoteConfigRepository? // di
    private let decoder: JSONDecoder? // di
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private lazy var _products = context?.rx
        .entities(fetchRequest: Product.fetchRequestWithSort()) ?? Observable.empty()
    private lazy var _groups = context?.rx
        .entities(fetchRequest: Group.fetchRequestWithSort()) ?? Observable.empty()
    
    init(remoteConfigRepository: RemoteConfigRepository?, decoder: JSONDecoder?) {
        self.remoteConfigRepository = remoteConfigRepository
        self.decoder = decoder
    }
    /** Get data from remote confic & decode it from JSON */
//    func productsAndGroups() -> Observable<[Group]>? {
//        remoteConfigRepository?.fetchAndActivate()?.map { [weak self] in
//            switch $0 {
//            case .failure(let error):
//                  throw error
//            default:
//                guard let self = self else {
//                    return []
//                }
//                // Check di
//                guard let decoder = self.decoder,
//                    let remoteConfig = self.remoteConfigRepository?.remoteConfig
//                    else { throw AppError.productsRepositoryDI }
//                // Decode JSON
//                let products = try decoder.decode(
//                    [Group].self,
//                    from: remoteConfig["products"].dataValue)
//                self.updateDB(groups: products)
//                return products
//            }
//
//        }
//    }
    
    func groups() -> Observable<[Group]> {
//        return context?.rx.entities(fetchRequest: Group.fetchRequestWithSort())
        _groups
    }
    
    func products() -> Observable<[Product]>? {
        let products: Observable<[GroupRemote]>? = remoteConfigRepository?.remoteData(key: "products")
        return products?.flatMap { [weak self] result -> Observable<[Product]> in
            guard let self = self, let context = self.context else {
                return Observable.empty()
            }
            try self.updateDB(groups: result)
            return context.rx.entities(fetchRequest: Product.fetchRequestWithSort())
        }
    }
    
    private func updateDB(groups: [GroupRemote]) throws {
        
        guard let context = context else {
            print("Context is nil. Nothing to update")
            throw AppError.productsRepositoryDI
        }
                
        try Group.clearEntity(context: context)
        
        var productOrder = 0
        groups.enumerated().forEach {
            context.insert($1.managedObject(context: context, groupOrder: $0, productOrder: &productOrder))
        }
        
        if context.hasChanges {
            try context.save()
        }
    }
    
}

extension AppError {
    static let productsRepositoryDI: AppError = .error("productsRepositoryDI")
}
