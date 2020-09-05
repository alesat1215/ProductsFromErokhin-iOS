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
    
    private var repository: ProductsRepository?
    
    init(repository: ProductsRepository?) {
        self.repository = repository
    }
    
    let products = Observable.just(["Product1", "Product2", "Product3", "Product4"])
    let products2 = Observable.just(["Product5", "Product6", "Product7", "Product8"])
    
    func productsRemote() -> Observable<[Group]>? {
        repository?.productsAndGroups()
    }
    
    func groups() -> Observable<[GroupInfo]>? {
        repository?.groups()
    }
}
