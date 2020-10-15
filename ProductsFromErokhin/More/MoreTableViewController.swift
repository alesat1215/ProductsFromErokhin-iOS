//
//  MoreTableViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoreTableViewController: UITableViewController {
    
    var viewModel: AboutAppViewModel? // di
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupShareAction()
    }
    
    private func setupShareAction() {        
        tableView.rx.itemSelected
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            .filter { $0.row == 3 }
            // Get appStore link
            .flatMapLatest { [weak self] _ -> Observable<AboutApp> in
                self?.aboutApp() ?? Observable.empty()
            }.compactMap { $0.appStore }
            // Share appStore link
            .flatMap { [weak self] in
                self?.rx.activity(activityItems: [$0]) ?? Observable.empty()
            }
            .flatMap { [weak self] result -> Observable<Bool> in
                // For error result show alert with error
                if let error = result.1 {
                    return self?.rx.showMessage(error.localizedDescription, withEvent: true)
                        .map { false } ?? Observable.empty()
                }
                // For success result send it status
                return Observable.just(result.0)
            }
            .filter { $0 }
            .subscribe(onNext: { _ in
                print("Share app success")
            }).disposed(by: disposeBag)
    }
    
    private func aboutApp() -> Observable<AboutApp> {
        viewModel?.aboutApp().take(1)
            .subscribeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }.compactMap { $0.first } ?? Observable.empty()
    }

}
