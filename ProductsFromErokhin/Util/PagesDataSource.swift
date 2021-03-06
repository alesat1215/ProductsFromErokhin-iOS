//
//  PagesDataSource.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 10.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class PagesDataSource<T: AnyObject>: NSObject, UIPageViewControllerDataSource {
    /** View controllers for UIPageViewController */
    private let pages: [UIViewController]
    
    /** Create pages for data */
    init(data: [T], storyboardId: String) {
        pages = data.map {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardId)
            (controller as? BindablePage)?.bind(model: $0)
            return controller
        }
    }
    
    /** Set dataSource, first page to page controller & return dataSource */
    func bind(to pageViewController: UIPageViewController?) -> Self {
        pageViewController?.dataSource = self
        if let firstPage = pages.first {
            pageViewController?
                .setViewControllers([firstPage], direction: .forward, animated: true)
        }
        return self
    }
    
    /** Check last page */
    func isLastPage(_ page: UIViewController) -> Bool {
        pages.last == page
    }
    
    //MARK: - DataSource
    
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

}
