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
extension NWPath: NWPathMethods { }
/** NWPathMonitor methods */
protocol NWPathMonitorMethods: AnyObject, ReactiveCompatible {
    associatedtype P: NWPathMethods
    var pathUpdateHandler: ((P) -> Void)? { get set }
    func start(queue: DispatchQueue)
    func cancel()
}
/** NWPath methods */
protocol NWPathMethods {
    var status: NWPath.Status { get }
}
/** Reactive wrapper for NWPathMonitor methods */
extension Reactive where Base: NWPathMonitorMethods {
    /** Generate true  */
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
