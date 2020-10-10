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
        viewModel?.previousPage(for: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        viewModel?.nextPage(for: viewController)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        viewModel?.pagesCount() ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        viewModel?.pageIndex(viewControllers?.first) ?? 0
    }
    
    func isLastPage(_ page: UIViewController) -> Bool {
        viewModel?.isLastPage(page) ?? false
    }
}
