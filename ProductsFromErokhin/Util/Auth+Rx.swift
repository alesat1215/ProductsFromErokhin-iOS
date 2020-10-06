//
//  Auth+Rx.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 06.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

extension Auth: AuthMethods { }

protocol AuthMethods: AnyObject, ReactiveCompatible {
    func signInAnonymously(completion: AuthDataResultCallback?)
}

extension Reactive where Base: AuthMethods {
    internal func signInAnonymously() -> Observable<Event<Void>> {
        Observable.create { observer in
            base.signInAnonymously { auth, error in
                if let error = error {
                    observer.onNext(Event.error(error))
                } else if auth != nil {
                    observer.onNext(Event.next(()))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
