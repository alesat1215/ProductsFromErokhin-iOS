//
//  LoadViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 16.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class LoadViewController: UIViewController {
    
    var viewModel: LoadViewModel? // di
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    /** Sign in to Firebase, load data & navigate to destination */
    private func loadData() {
//        viewModel?.auth()
//            .observeOn(MainScheduler.instance)
//            .flatMapError { [weak self] in
//                self?.rx.showMessage($0.localizedDescription, withEvent: false) ?? Observable.empty()
//            }
//            // Load data
//            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
//            .flatMapLatest { [weak self] in
//                self?.viewModel?.loadComplete() ?? Observable.empty()
//            }
//            .observeOn(MainScheduler.instance)
//            .flatMapError { [weak self] in
//                self?.rx.showMessage($0.localizedDescription, withEvent: false) ?? Observable.empty()
//            }
//            .filter { $0 }
//            .map { _ in return }
        // Auth in Firebase
        auth()
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            // Load data
            .flatMapLatest { [weak self] in
                self?.load() ?? Observable.empty()
            }
            // Navigate to destination
            .subscribe(onNext: { [weak self] in
                print("Load complete. Navigate to destination")
                self?.performSegue(withIdentifier: "toStart", sender: nil)
            }).disposed(by: disposeBag)
    }
    
    private func auth() -> Observable<Void> {
        viewModel?.auth()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription, withEvent: false) ?? Observable.empty()
            } ?? Observable.empty()
    }
    
    private func load() -> Observable<Void> {
        viewModel?.loadComplete()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription, withEvent: false) ?? Observable.empty()
            }
            .filter { $0 }
            .map { _ in return } ?? Observable.empty()
    }

}
