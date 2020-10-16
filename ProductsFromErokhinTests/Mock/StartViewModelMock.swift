//
//  StartViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class StartViewModelMock: StartViewModel {
    
    let titlesResult = PublishRelay<Event<[Titles]>>()
    func titles() -> Observable<Event<[Titles]>> {
        titlesResult.asObservable()
    }
    
    let productsResult = PublishRelay<Event<CoreDataSourceCollectionView<Product>>>()
    func products() -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        productsResult.asObservable()
    }
    
    let productsResult2 = PublishRelay<Event<CoreDataSourceCollectionView<Product>>>()
    func products2() -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        productsResult2.asObservable()
    }
}
