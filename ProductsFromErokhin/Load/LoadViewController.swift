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
        viewModel?.auth()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription, withEvent: false) ?? Observable.empty()
            }
            // Load data
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .flatMapLatest { [weak self] in
                self?.viewModel?.loadComplete() ?? Observable.empty()
            }
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription, withEvent: false) ?? Observable.empty()
            }
            .filter { $0 }
            .map { _ in return }
            .subscribe(onNext: { [weak self] in
//                if $0 {
//                    self?.performSegue(withIdentifier: "toStart", sender: nil)
//                    print("Load complete. Navigate to destination")
//                } else { print("Load incomplete") }
                print("Load complete. Navigate to destination")
                self?.performSegue(withIdentifier: "toStart", sender: nil)
            }).disposed(by: disposeBag)
    }

}
