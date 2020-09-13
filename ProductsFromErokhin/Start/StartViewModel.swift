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
    
    func titles() -> Observable<Event<[Titles]>> {
        repository.titles()
    }
    
    func products() -> Observable<Event<[Product]>> {
        repository.products()
    }
    
    lazy var products2 = repository.products2(predicate: NSPredicate(format: "inStart2 == %@", NSNumber(value: true)))
}
