//
//  StartViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

class StartViewModel {
    
    private var repository: ProductsRepository! // di
    
    init(repository: ProductsRepository?) {
        self.repository = repository
    }
    
    let products1 = Observable.just(["Product1", "Product2", "Product3", "Product4"])
    let products2 = Observable.just(["Product5", "Product6", "Product7", "Product8"])
        
    func groups() -> Observable<Event<[Group]>> {
        repository.groups()
    }
    
    func products() -> Observable<Event<[Product]>> {
        repository.products()
    }
}
