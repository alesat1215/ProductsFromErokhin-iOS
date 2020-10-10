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
    var pages: [UIViewController]? { get }
    func previousPage(for page: UIViewController) -> UIViewController?
    func nextPage(for page: UIViewController) -> UIViewController?
    func pagesCount() -> Int
    func pageIndex(_ page: UIViewController?) -> Int
    func isLastPage(_ page: UIViewController) -> Bool
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
    
    func isLastPage(_ page: UIViewController) -> Bool {
        pages?.last == page
    }
    
    func pagesCount() -> Int {
        pages?.count ?? 0
    }
    
    func pageIndex(_ page: UIViewController?) -> Int {
        guard let page = page else {
            return 0
        }
        return pages?.firstIndex(of: page) ?? 0
    }
}
