//
//  TutorialViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class TutorialViewModelMock: TutorialViewModel {
    
    let instructionsResult = PublishRelay<Event<[Instruction]>>()
    func instructions() -> Observable<Event<[Instruction]>> {
        instructionsResult.asObservable()
    }
    
    var isReadTutorial = false
    func readTutorial() {
        isReadTutorial.toggle()
    }
    
    
}
