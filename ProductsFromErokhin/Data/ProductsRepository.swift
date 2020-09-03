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
    
    init(remoteConfigRepository: RemoteConfigRepository?) {
        self.remoteConfigRepository = remoteConfigRepository
    }
    
    func productsAndGroups() -> Observable<String>? {
        remoteConfigRepository?.fetchAndActivate()?.map { [weak self] in
            self?.remoteConfigRepository?.remoteConfig?["products"].stringValue ?? ""
        }
    }
}
