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
//    func pageCount() -> Observable<Int>
    var pages: [UIViewController]? { get }
    func previousPage(for page: UIViewController) -> UIViewController?
    func nextPage(for page: UIViewController) -> UIViewController?
}

class TutorialViewModelImpl: TutorialViewModel {
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    var pages: [UIViewController]?
    
    private lazy var _instructions = repository.instructions().share(replay: 1, scope: .forever)
    
    func instructions() -> Observable<Event<[Instruction]>> {
        _instructions
            // Set pages
            .do(onNext: { [weak self] in
                self?.pages = $0.element?.map { model -> UIViewController in
                    let controller = UIStoryboard(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "InstructionViewController")
                    (controller as? BindablePage)?.bind(model: model)
                    return controller
                }
            })
    }
    
    func previousPage(for page: UIViewController) -> UIViewController? {
        guard let pages = pages, let index = pages.firstIndex(of: page) else {
            return nil
        }
        let previousIndex = index - 1
        if pages.indices.contains(previousIndex) {
            return pages[previousIndex]
        }
        return nil
    }
    
    func nextPage(for page: UIViewController) -> UIViewController? {
        guard let pages = pages, let index = pages.firstIndex(of: page) else {
            return nil
        }
        let nextIndex = index + 1
        if pages.indices.contains(nextIndex) {
            return pages[nextIndex]
        }
        return nil
    }
    
//    func pageCount() -> Observable<Int> {
//        _instructions.map { $0.element?.count ?? 0 }
//    }
}
