//
//  LoadViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift
@testable import ProductsFromErokhin

class LoadViewModelMock: LoadViewModel {
    
    init() {
        super.init(repository: nil, anonymousAuth: nil)
    }
    
    var authResult: Event<Void> = Event.error(AppError.unknown)
    override func auth() -> Observable<Event<Void>> {
        Observable.just(authResult)
    }
    
    let loadCompleteResult = PublishRelay<Event<Bool>>()
    override func loadComplete() -> Observable<Event<Bool>> {
        loadCompleteResult.asObservable()
    }
}
