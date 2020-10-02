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
    /** Show alert with text & OK button */
    public func showMessage(_ text: String) -> Observable<Void> {
        alert(title: nil,
              message: text,
              actions: [AlertAction(title: "OK", style: .default)]
        ).map { _ in () }
    }
}
