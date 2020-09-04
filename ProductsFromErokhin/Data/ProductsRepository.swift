//
//  ProductsRepository.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

class ProductsRepository {
    private let remoteConfigRepository: RemoteConfigRepository?
    private let decoder = JSONDecoder()
    
    init(remoteConfigRepository: RemoteConfigRepository?) {
        self.remoteConfigRepository = remoteConfigRepository
    }
    /** Get data from remote confic & decode it from JSON */
    func productsAndGroups() -> Observable<[Group]>? {
        remoteConfigRepository?.fetchAndActivate()?.map { [weak self] in
            switch $0 {
            case .failure(let error):
                  throw error
            default:
                let products = try self?.decoder.decode(
                    [Group].self,
                    from: (self?.remoteConfigRepository?.remoteConfig?["products"].dataValue)!)
                return products ?? []
            }
            
        }
    }
}
