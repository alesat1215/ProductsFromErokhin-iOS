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
    /** Set true for key TutorialKey.tutorialIsRead in UserDefaults in global queue */
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
    /** Set true for key TutorialKey.tutorialIsRead in UserDefaults in global queue */
    func readTutorial() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.userDefaults.set(true, forKey: TutorialKey.tutorialIsRead.rawValue)
        }
    }
}
