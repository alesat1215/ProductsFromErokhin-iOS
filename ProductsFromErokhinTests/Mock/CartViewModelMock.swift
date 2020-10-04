//
//  CartViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
@testable import ProductsFromErokhin

class CartViewModelMock: CartViewModel {
    
    init() {
        super.init(repository: nil, contactStore: nil)
    }
    
    var inCartCountResult: String?
    override func inCartCount() -> Observable<String?> {
        Observable.just(inCartCountResult)
    }
    
    var clearCartResult: Result<Void, Error> = .success(())
    override func clearCart() -> Result<Void, Error> {
        clearCartResult
    }
}
