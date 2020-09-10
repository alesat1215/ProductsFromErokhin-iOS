//
//  ObservableType+Extensions.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 10.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where Element: EventConvertible {
    /**
     Dematerilize Observable`<Event<Element>>` without error. For error event run handler & return empty observable.
     - parameter handler: handler for error.
     - returns: An observable sequence without error.
     */
    func flatMapError(_ handler: ((_ error: Error) -> ())? = nil) -> Observable<Element.Element> {
        flatMap { element -> Observable<Element.Element> in
            switch element.event {
            case .error(let error):
                handler?(error)
                return Observable.empty()
            case .next(let element):
                return Observable.just(element)
            default:
                return Observable.empty()
            }
        }
    }
}
