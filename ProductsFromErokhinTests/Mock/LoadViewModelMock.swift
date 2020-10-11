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
    
    var tutorialIsReadResult = false
    var isRead = false
    func tutorialIsRead() -> Bool {
        isRead.toggle()
        return tutorialIsReadResult
    }
    
    let authResult = PublishRelay<Event<Void>>()
    func auth() -> Observable<Event<Void>> {
        authResult.asObservable()
    }
    
    let loadCompleteResult = PublishRelay<Event<Bool>>()
    var isLoadComplete = false
    func loadComplete() -> Observable<Event<Bool>> {
        isLoadComplete.toggle()
        return loadCompleteResult.asObservable()
    }
}
