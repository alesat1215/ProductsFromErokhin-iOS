//
//  UIViewController+Rx.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 01.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxUIAlert

extension Reactive where Base: UIViewController {
    /**
     Reactive wrapper for completionWithItemsHandler of UIActivityViewController.
     - Returns: - State of completed & error
     */
    public func activity(activityItems: [Any]) -> Observable<(Bool, Error?)> {
        let view = base.view
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return Observable.create { [weak view] observer in
            guard let view = view else { return Disposables.create() }
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
                observer.onNext((completed, activityError))
                observer.on(.completed)
            }
            
            return Disposables.create { activityViewController.dismiss(animated: true) }
        }.do(onSubscribe: {
                self.base.present(activityViewController, animated: true)
        })
    }
}

extension Reactive where Base: UIViewController {
    /**
     Show alert with text & OK button. For withEvent == false result is Observable.empty()
     - Parameters:
        - text: Text for message
        - withEvent: If true return sequence with one event. Default return empty sequence
     */
    public func showMessage(_ text: String, withEvent: Bool = false) -> Observable<Void> {
        let _alert = alert(title: nil,
              message: text,
              actions: [AlertAction(title: "OK", style: .default)]
        ).map { _ in () }
        return withEvent ? _alert : _alert.flatMap { Observable.empty() }
    }
}
