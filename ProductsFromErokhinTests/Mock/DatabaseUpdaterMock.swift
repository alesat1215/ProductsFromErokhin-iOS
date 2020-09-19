//
//  DatabaseUpdaterMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
@testable import ProductsFromErokhin

class DatabaseUpdaterMock: DatabaseUpdater {
    init() {
        super.init(remoteConfig: nil, remoteConfigComplection: nil, decoder: nil, context: nil, fetchLimiter: nil)
    }
    var error: Error?
    var isSync = false
    override func sync<T>() -> Observable<Event<T>> {
        isSync.toggle()
        if let error = error {
            return Observable.just(Event.error(error))
        }
        return Observable.empty()
    }
}
