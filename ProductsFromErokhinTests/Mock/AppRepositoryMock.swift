//
//  AppRepositoryMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class AppRepositoryMock: AppRepository {
    
    init() {
        super.init(updater: nil, context: nil)
    }
    
    var titlesResult = [Titles(context: ContextMock())]
    override func titles() -> Observable<Event<[Titles]>> {
        Observable.just(Event.next(titlesResult))
    }
    
    let productsResult = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
    var predicate: NSPredicate?
    var cellId: String?
    override func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        self.predicate = predicate
        self.cellId = cellId
        return Observable.just(Event.next(productsResult))
    }
}
