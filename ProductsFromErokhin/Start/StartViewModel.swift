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
    
    private let repository: ProductsRepository! // di
    private let anonymousAuth: AnonymousAuth! // di
    
    init(repository: ProductsRepository?, anonymousAuth: AnonymousAuth?) {
        self.repository = repository
        self.anonymousAuth = anonymousAuth
    }
    
    func titles() -> Observable<Event<[Titles]>> {
        repository.titles()
    }
    
    func products() -> Observable<Event<CoreDataSource<Product>>> {
        repository.products(
            predicate: NSPredicate(format: "inStart == %@", NSNumber(value: true)),
            cellId: "product"
        )
    }
    
    func products2() -> Observable<Event<CoreDataSource<Product>>> {
        repository.products(
            predicate: NSPredicate(format: "inStart2 == %@", NSNumber(value: true)),
            cellId: "product"
        )
    }
    
    func auth() -> Observable<Event<Void>> {
        anonymousAuth.signIn()
    }
}
