//
//  LoadViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 16.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

protocol LoadViewModel {
    func auth() -> Observable<Event<Void>>
    func loadComplete() -> Observable<Event<Bool>>
    func tutorialIsRead() -> Bool
}

class LoadViewModelImpl<T: AuthMethods>: LoadViewModel {
    private let repository: AppRepository! // di
    private let anonymousAuth: T! // di
    private let userDefaults: UserDefaults! // di
    
    init(repository: AppRepository?, anonymousAuth: T?, userDefaults: UserDefaults?) {
        self.repository = repository
        self.anonymousAuth = anonymousAuth
        self.userDefaults = userDefaults
    }
    
    func auth() -> Observable<Event<Void>> {
        anonymousAuth.rx.signInAnonymously()
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
    
    func tutorialIsRead() -> Bool {
        userDefaults.bool(forKey: TutorialKey.tutorialIsRead.rawValue)
    }
}
