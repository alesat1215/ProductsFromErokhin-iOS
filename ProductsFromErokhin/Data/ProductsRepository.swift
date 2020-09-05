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
    private let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    init(remoteConfigRepository: RemoteConfigRepository?, decoder: JSONDecoder?) {
        self.remoteConfigRepository = remoteConfigRepository
        self.decoder = decoder
    }
    /** Get data from remote confic & decode it from JSON */
    func productsAndGroups() -> Observable<[Group]>? {
        remoteConfigRepository?.fetchAndActivate()?.map { [weak self] in
            switch $0 {
            case .failure(let error):
                  throw error
            default:
                guard let self = self else {
                    return []
                }
                // Check di
                guard let decoder = self.decoder,
                    let remoteConfig = self.remoteConfigRepository?.remoteConfig
                    else { throw AppError.productsRepositoryDI }
                // Decode JSON
                let products = try decoder.decode(
                    [Group].self,
                    from: remoteConfig["products"].dataValue)
                self.updateGroups(groups: products)
                return products
            }
            
        }
    }
    
    func groups() -> Observable<[GroupInfo]>? {
        let fetchRequest: NSFetchRequest<GroupInfo> = GroupInfo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \GroupInfo.order, ascending: true)]
        return context?.rx.entities(fetchRequest: fetchRequest)
    }
    
    func updateGroups(groups: [Group]) {
        let del = NSBatchDeleteRequest(fetchRequest: GroupInfo.fetchRequest())
        
        do {
            try context?.execute(del)
        } catch {
            print(error)
        }
        
        groups.enumerated().forEach {
            let groupInfo = NSEntityDescription.insertNewObject(forEntityName: "GroupInfo", into: context!)
            groupInfo.setValue(Int16($0), forKey: "order")
            groupInfo.setValue($1.name, forKey: "name")
            context?.insert(groupInfo)
        }
        if context?.hasChanges ?? false {
            do {
                try context?.save()
            } catch let error {
                print(error)
            }
        }
    }
}

extension AppError {
    static let productsRepositoryDI: AppError = .error("productsRepositoryDI")
}
