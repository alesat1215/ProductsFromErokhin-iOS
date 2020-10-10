//
//  TutorialViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 09.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

protocol TutorialViewModel: AnyObject {
    func instructions() -> Observable<Event<[Instruction]>>
    func readTutorial() -> Void
}

class TutorialViewModelImpl: TutorialViewModel {
    
    private let repository: AppRepository! // di
    private let userDefaults: UserDefaults! // di
    
    init(repository: AppRepository?, userDefaults: UserDefaults?) {
        self.repository = repository
        self.userDefaults = userDefaults
    }
    
    func instructions() -> Observable<Event<[Instruction]>> {
        repository.instructions()
    }
    
    func readTutorial() {
        userDefaults.set(true, forKey: TutorialKey.tutorialIsRead.rawValue)
    }
}
