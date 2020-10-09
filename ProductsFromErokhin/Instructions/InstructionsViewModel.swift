//
//  InstructionsViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 09.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

protocol InstructionsViewModel {
    func instructions() -> Observable<Event<[Instruction]>>
    func pageCount() -> Observable<Int>
}

class InstructionsViewModelImpl: InstructionsViewModel {
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    private lazy var _instructions = repository.instructions().share(replay: 1, scope: .forever)
    
    func instructions() -> Observable<Event<[Instruction]>> {
        _instructions
    }
    
    func pageCount() -> Observable<Int> {
        _instructions.map { $0.element?.count ?? 0 }
    }
}
