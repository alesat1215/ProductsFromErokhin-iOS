//
//  TabBarViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 30.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

class TabBarViewModel {
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    func inCartCount() -> Observable<String> {
        repository.products(predicate: NSPredicate(format: "inCart.@count != 0"))
            .map { String($0.count) }
    }
}
