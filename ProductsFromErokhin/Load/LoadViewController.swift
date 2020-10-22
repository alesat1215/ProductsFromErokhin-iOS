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
    
    @IBAction func unwindToLoad(_ unwindSegue: UIStoryboardSegue) {
        DispatchQueue.main.async { [weak self] in
            print("Navigate to start")
            self?.performSegue(withIdentifier: "toStart", sender: nil)
        }
    }
    
    var viewModel: LoadViewModel? // di
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    /** Sign in to Firebase, load data & navigate to destination */
    private func loadData() {
        // Sign in to Firebase
        auth()
            // Load data
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .flatMapLatest { [weak self] in
                self?.load() ?? Observable.empty()
            }
            // Navigate to destination
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                print("Load complete")
                if self?.viewModel?.tutorialIsRead() ?? true {
                    print("Navigate to start")
                    self?.performSegue(withIdentifier: "toStart", sender: nil)
                } else {
                    print("Navigate to tutorial")
                    self?.performSegue(withIdentifier: "toTutorial", sender: nil)
                }
            }).disposed(by: disposeBag)
    }
    /** Sign in to Firebase */
    private func auth() -> Observable<Void> {
        viewModel?.auth()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            } ?? Observable.empty()
    }
    /** Load data */
    private func load() -> Observable<Void> {
        viewModel?.loadComplete()
            .subscribeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            } ?? Observable.empty()
    }
    
    

}
