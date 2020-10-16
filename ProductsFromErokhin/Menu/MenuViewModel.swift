//
//  MenuViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 21.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

protocol MenuViewModel {
    func groups() -> Observable<Event<CoreDataSourceCollectionView<Group>>>
    func products() -> Observable<Event<CoreDataSourceTableView<Product>>>
}

class MenuViewModelImpl: MenuViewModel {
    private let repository: Repository! // di
    
    init(repository: Repository?) {
        self.repository = repository
    }
    
    func groups() -> Observable<Event<CoreDataSourceCollectionView<Group>>> {
        repository.groups(cellId: ["group"])
    }
    
    func products() -> Observable<Event<CoreDataSourceTableView<Product>>> {
        repository.products(predicate: nil, cellId: "product")
    }
}
