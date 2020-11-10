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
    /** Need because dataSource is weak */
    private var _dataSource: UIPageViewControllerDataSource?
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindDataSource()
    }
    /** Set dataSource for page controller & save to _dataSource */
    private func bindDataSource() {
        viewModel?.instructions()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
            .map { PagesDataSource(data: $0, storyboardId: "InstructionViewController") }
            .subscribe(onNext: { [weak self] in
                self?._dataSource = $0.bind(to: self)
            }).disposed(by: disposeBag)
    }

}

