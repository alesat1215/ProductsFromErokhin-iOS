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
    
    init() {
        super.init(repository: nil)
    }
    
    let titlesResult = PublishRelay<Event<[Titles]>>()
    override func titles() -> Observable<Event<[Titles]>> {
        titlesResult.asObservable()
    }
    
    let productsResult = PublishRelay<Event<CoreDataSource<Product>>>()
    override func products() -> Observable<Event<CoreDataSource<Product>>> {
        productsResult.asObservable()
    }
    
    let productsResult2 = PublishRelay<Event<CoreDataSource<Product>>>()
    override func products2() -> Observable<Event<CoreDataSource<Product>>> {
        productsResult2.asObservable()
    }
}
