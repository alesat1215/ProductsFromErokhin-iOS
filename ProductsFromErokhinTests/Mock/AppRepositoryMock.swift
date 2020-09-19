//
//  AppRepositoryMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class AppRepositoryMock: AppRepository {
    
    let titlesResult = PublishRelay<Event<[Titles]>>()
    override func titles() -> Observable<Event<[Titles]>> {
        titlesResult.asObservable()
    }
    
    let productsResult = PublishRelay<Event<CoreDataSource<Product>>>()
    var predicate: NSPredicate?
    var cellId: String?
    override func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSource<Product>>> {
        self.predicate = predicate
        self.cellId = cellId
        return productsResult.asObservable()
    }
}
