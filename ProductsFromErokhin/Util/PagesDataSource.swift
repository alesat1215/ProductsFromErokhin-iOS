//
//  PagesDataSource.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 10.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class PagesDataSource<T: AnyObject>: NSObject, UIPageViewControllerDataSource {
    
    private let pages: [UIViewController]
    
    init(data: [T], storyboardId: String, viewModel: TutorialViewModel?) {
        pages = data.map {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardId)
            (controller as? BindablePage)?.bind(model: $0)
            (controller as? InstructionViewController)?.viewModel = viewModel
            return controller
        }
    }
    
    func bind(to pageViewController: UIPageViewController?) -> UIPageViewControllerDataSource {
        pageViewController?.dataSource = self
        if let firstPage = pages.first {
            pageViewController?
                .setViewControllers([firstPage], direction: .forward, animated: true)
        }
        return self
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
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let page = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: page)
        { return index }
        return 0
    }
    
    func isLastPage(_ page: UIViewController) -> Bool {
        pages.last == page
    }
    
}
