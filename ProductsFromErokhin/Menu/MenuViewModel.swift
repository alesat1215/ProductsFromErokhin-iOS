//
//  MenuViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 21.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

class MenuViewModel {
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    func products() -> Observable<Event<CoreDataSourceTableView<Product>>> {
        repository.products(predicate: nil, cellId: "product")
    }
}
