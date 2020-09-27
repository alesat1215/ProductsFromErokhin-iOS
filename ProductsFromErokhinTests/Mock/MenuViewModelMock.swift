//
//  MenuViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 27.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class MenuViewModelMock: MenuViewModel {
    init() {
        super.init(repository: nil)
    }
    
    let groupsResult = PublishRelay<Event<CoreDataSourceCollectionView<Group>>>()
    override func groups() -> Observable<Event<CoreDataSourceCollectionView<Group>>> {
        groupsResult.asObservable()
    }
    
    let productsResult = PublishRelay<Event<CoreDataSourceTableView<Product>>>()
    override func products() -> Observable<Event<CoreDataSourceTableView<Product>>> {
        productsResult.asObservable()
    }
}
