//
//  AnonymousAuth.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 16.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxRelay

/** Sign in to Firebase Auth as anonymous */
class AnonymousAuth {
    private let auth: Auth? // di
    private let authComplection: AuthComplection? // di
    
    init(auth: Auth?, authComplection: AuthComplection?) {
        self.auth = auth
        self.authComplection = authComplection
    }
    
    func signIn() -> Observable<Event<Void>> {
        auth?.signInAnonymously(completion: authComplection?.complection(result:error:))
        
        return authComplection?.result().flatMap { _, error -> Observable<Event<Void>> in
            if let error = error {
                return Observable.just(Event.error(error))
            }
            return Observable.just(Event.next(()))
        } ?? Observable.empty()
    }
}
/** Observable complection for Firebase Auth */
protocol AuthComplection {
    func complection(result: AuthDataResult?, error: Error?)
    func result() -> Observable<(result: AuthDataResult?, error: Error?)>
}

class AuthComplectionImpl: AuthComplection {
    private let _result = PublishRelay<(result: AuthDataResult?, error: Error?)>()
    
    func complection(result: AuthDataResult?, error: Error?) {
        _result.accept((result, error))
    }
    
    func result() -> Observable<(result: AuthDataResult?, error: Error?)> {
        _result.asObservable()
    }
}
