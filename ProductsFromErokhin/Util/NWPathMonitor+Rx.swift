//
//  NWPathMonitor+Rx.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 22.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import Network
import RxSwift

extension NWPathMonitor: NWPathMonitorMethods { }

protocol NWPathMonitorMethods: AnyObject, ReactiveCompatible {
    var pathUpdateHandler: ((NWPath) -> Void)? { get set }
    func start(queue: DispatchQueue)
    func cancel()
}

extension Reactive where Base: NWPathMonitorMethods {
    internal func status() -> Observable<Bool> {
        Observable.create { observer in
            base.pathUpdateHandler = { path in
                switch path.status {
                case .satisfied:
                    observer.onNext(true)
                default:
                    observer.onNext(false)
                }
            }
            base.start(queue: DispatchQueue(label: "Monitor"))
            return Disposables.create { base.cancel() }
        }
    }
}
