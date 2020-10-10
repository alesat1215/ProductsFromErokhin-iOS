//
//  TutorialViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 09.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class TutorialViewController: UIPageViewController {
    
    var viewModel: TutorialViewModel? // di
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindDataSource()
    }
    
    private func bindDataSource() {
        viewModel?.instructions()
            .subscribeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
//                self?.rx.dataSource(data: $0, storyboardId: "InstructionViewController")
                guard let self = self, let firstPage = self.viewModel?.pages?.first else {
                    return
                }
                self.dataSource = self
                self.setViewControllers([firstPage], direction: .forward, animated: true)
            }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let pages = viewModel?.pages, let index = pages.firstIndex(of: viewController) else {
//            return nil
//        }
//        let previousIndex = index - 1
//        if pages.indices.contains(previousIndex) {
//            return pages[previousIndex]
//        }
//        return nil
        viewModel?.previousPage(for: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let pages = viewModel?.pages, let index = pages.firstIndex(of: viewController) else {
//            return nil
//        }
//        let nextIndex = index + 1
//        if pages.indices.contains(nextIndex) {
//            return pages[nextIndex]
//        }
//        return nil
        viewModel?.nextPage(for: viewController)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        viewModel?.pages?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let page = viewControllers?.first,
              let index = viewModel?.pages?.firstIndex(of: page)
        else { return 0 }
        return index
    }
}

class PageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    private let pages: [UIViewController]
    
    init(pages: [UIViewController]) {
        self.pages = pages
    }
    
//    func firstPage() -> UIViewController? {
//        pages.first
//    }
    
    func isFirstPage(viewController: UIViewController) -> Bool {
        pages.firstIndex(of: viewController) == 0
    }
    
    func isLastPage(viewController: UIViewController) -> Bool {
        pages.firstIndex(of: viewController) == pages.count - 1
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = index - 1
        if pages.indices.contains(previousIndex) {
            return pages[previousIndex]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = index + 1
        if pages.indices.contains(nextIndex) {
            return pages[nextIndex]
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
    
}
