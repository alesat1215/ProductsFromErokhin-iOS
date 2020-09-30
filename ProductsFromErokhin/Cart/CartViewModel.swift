//
//  CartViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 29.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class CartViewModel {
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    /** Current products in dataSource */
    private let _products = ReplaySubject<[Product]>.create(bufferSize: 1)
    
    func products() -> Observable<Event<CoreDataSourceTableView<Product>>> {
        repository.products(
            predicate: NSPredicate(format: "inCart.@count != 0"),
            cellId: "product"
        ).dematerialize().do(onNext: { [weak self] dataSource in
            // Set current products from dataSorce
            dataSource.currentData = {
                self?._products.onNext($0)
                print("Set current products in cart: \($0.count)")
            }
        }).materialize()
    }
    
    /** Sum for order */
    func totalInCart() -> Observable<Int> {
        _products.map { $0.map { $0.priceSumInCart() }.reduce(0, +) }
    }
}
