//
//  TutorialViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
@testable import ProductsFromErokhin

class TutorialViewModelMock: TutorialViewModel {
    func instructions() -> Observable<Event<[Instruction]>> {
        Observable.empty()
    }
    
    var isReadTutorial = false
    func readTutorial() {
        isReadTutorial.toggle()
    }
    
    
}
