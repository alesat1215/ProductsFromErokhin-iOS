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
    
    init() {}
    
    let nwAvailableResult = PublishRelay<Bool>()
    func nwAvailable() -> Observable<Bool> {
        nwAvailableResult.asObservable()
    }
    
    let authResult = PublishRelay<Event<Void>>()
    var isAuth = false
    func auth() -> Observable<Event<Void>> {
        isAuth.toggle()
        return authResult.asObservable()
    }
    
    let loadCompleteResult = PublishRelay<Event<Void>>()
    var isLoadComplete = false
    func loadComplete() -> Observable<Event<Void>> {
        isLoadComplete.toggle()
        return loadCompleteResult.asObservable()
    }
    
    var tutorialIsReadResult = false
    var isRead = false
    func tutorialIsRead() -> Bool {
        isRead.toggle()
        return tutorialIsReadResult
    }
}
