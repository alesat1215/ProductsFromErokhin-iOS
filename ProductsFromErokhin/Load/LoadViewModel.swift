//
//  LoadViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 16.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

class LoadViewModel {
    private let repository: ProductsRepository! // di
    private let anonymousAuth: AnonymousAuth! // di
    
    init(repository: ProductsRepository?, anonymousAuth: AnonymousAuth?) {
        self.repository = repository
        self.anonymousAuth = anonymousAuth
    }
    
    func auth() -> Observable<Event<Void>> {
        anonymousAuth.signIn()
    }
    
    func loadComplete() -> Observable<Event<Bool>> {
        repository.titles().map {
            switch $0 {
            case .next(let array):
                return Event.next(!array.isEmpty)
            case .error(let error):
                return Event.error(error)
            case .completed:
                return Event.completed
            }
        }
    }
}
