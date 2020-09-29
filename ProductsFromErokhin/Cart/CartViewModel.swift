//
//  CartViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 29.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

class CartViewModel {
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    func products() -> Observable<Event<CoreDataSourceTableView<Product>>> {
        repository.products(predicate: NSPredicate(format: "inCart.@count != 0"), cellId: "product")
    }
}
