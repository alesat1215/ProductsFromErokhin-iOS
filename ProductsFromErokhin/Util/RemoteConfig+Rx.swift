//
//  RemoteConfig+Rx.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 06.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift

extension RemoteConfig: RemoteConfigMethods { }
/** Firebase remote config methods */
protocol RemoteConfigMethods: AnyObject, ReactiveCompatible {
    func fetchAndActivate(completionHandler: ((RemoteConfigFetchAndActivateStatus, Error?) -> Void)?)
    subscript(_ key: String) -> RemoteConfigValue { get }
}
/** Reactive wrapper for firebase remote config methods */
extension Reactive where Base: RemoteConfigMethods {
    /** Generate event with status & error. If error == nil complete sequence */
    internal func fetchAndActivate() -> Observable<(status: RemoteConfigFetchAndActivateStatus, error: Error?)> {
        Observable.create { observer in
            base.fetchAndActivate { status, error in
                observer.onNext((status, error))
                if error == nil {
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
