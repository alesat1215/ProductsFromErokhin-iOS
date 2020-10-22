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
    func nwAvailable() -> Observable<Bool>
    func auth() -> Observable<Event<Void>>
    func loadComplete() -> Observable<Event<Void>>
    func tutorialIsRead() -> Bool
}

class LoadViewModelImpl<T: AuthMethods, M: NWPathMonitorMethods>: LoadViewModel {
    private let repository: Repository! // di
    private let anonymousAuth: T! // di
    private let userDefaults: UserDefaults! // di
    private let monitor: M! // di
    
    init(
        repository: Repository?,
        anonymousAuth: T?,
        userDefaults: UserDefaults?,
        monitor: M?
    ) {
        self.repository = repository
        self.anonymousAuth = anonymousAuth
        self.userDefaults = userDefaults
        self.monitor = monitor
    }
    
    func nwAvailable() -> Observable<Bool> {
        monitor.rx.status()
    }
    
    func auth() -> Observable<Event<Void>> {
        anonymousAuth.rx.signInAnonymously()
    }
    
    func loadComplete() -> Observable<Event<Void>> {
        repository.loadData().ifEmpty(default: Event.next(()))
    }
    
    func tutorialIsRead() -> Bool {
        userDefaults.bool(forKey: TutorialKey.tutorialIsRead.rawValue)
    }
}
