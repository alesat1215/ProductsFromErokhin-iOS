//
//  AnonymousAuthMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
@testable import ProductsFromErokhin

class AnonymousAuthMock: AnonymousAuth {
    
    init() {
        super.init(auth: nil, authComplection: nil)
    }
    
    let signInResult: Void = ()
    override func signIn() -> Observable<Event<Void>> {
        Observable.just(Event.next(signInResult))
    }
}
