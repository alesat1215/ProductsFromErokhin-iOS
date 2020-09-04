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
    private let remoteConfigRepository: RemoteConfigRepository? // di
    private let decoder: JSONDecoder? // di
    
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
                return products
            }
            
        }
    }
}

extension AppError {
    static let productsRepositoryDI: AppError = .error("productsRepositoryDI")
}
