//
//  TutorialViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 09.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

protocol TutorialViewModel {
    func instructions() -> Observable<Event<[Instruction]>>
}

class TutorialViewModelImpl: TutorialViewModel {
    
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    func instructions() -> Observable<Event<[Instruction]>> {
        repository.instructions()
    }
}
