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
    
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    func titles() -> Observable<Event<[Titles]>> {
        repository.titles()
    }
    
    func products() -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        repository.products(
            predicate: NSPredicate(format: "inStart == %@", NSNumber(value: true)),
            cellId: ["product"]
        )
    }
    
    func products2() -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        repository.products(
            predicate: NSPredicate(format: "inStart2 == %@", NSNumber(value: true)),
            cellId: ["product"]
        )
    }

}
