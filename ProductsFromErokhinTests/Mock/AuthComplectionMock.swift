//
//  AuthComplectionMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 17.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
@testable import ProductsFromErokhin

class AuthComplectionMock: AuthComplection {
    
    let error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func complection(result: AuthDataResult?, error: Error?) {
        
    }
    
    func result() -> Observable<(result: AuthDataResult?, error: Error?)> {
        Observable.just((nil, error))
    }
    
    
}