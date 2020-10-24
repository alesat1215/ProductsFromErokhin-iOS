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
    
    @IBOutlet weak var loading: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var connectionError: UIStackView!
    
    var viewModel: LoadViewModel? // di
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        connect()
    }
    
    /** Setup visible for activity & connection error. Load data if connection available */
    private func connect() {
        viewModel?.nwAvailable()
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            // Show or hidden connection error
            .do(onNext: { [weak self] in
                self?.connectionError.isHidden = $0
                $0 ? self?.activity.startAnimating() : self?.activity.stopAnimating()
            })
            // Load data if connection is enable
            .filter { $0 }.flatMap { [weak self] _ in
                self?.loadData() ?? Observable.empty()
            }.take(1)
            // Navigate to destination & terminate sequence
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.loading.text = NSLocalizedString("loadComplete", comment: "")
                print("Load complete")
                // Navigate
                if self?.viewModel?.tutorialIsRead() ?? true {
                    print("Navigate to start")
                    self?.performSegue(withIdentifier: "toStart", sender: nil)
                } else {
                    print("Navigate to tutorial")
                    self?.performSegue(withIdentifier: "toTutorial", sender: nil)
                }
            }).disposed(by: disposeBag)
    }
    
    /** Sign in to Firebase, load data & navigate to destination */
    private func loadData() -> Observable<Void> {
        // Sign in to Firebase
        Observable.just(NSLocalizedString("authentication", comment: ""))
            .map { [weak self] in
                self?.loading.text = $0
            }
            .flatMapLatest { [weak self] in
                self?.auth() ?? Observable.empty()
            }
            // Load data
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .flatMapLatest { [weak self] in
                self?.load() ?? Observable.empty()
            }
    }
    /** Sign in to Firebase */
    private func auth() -> Observable<Void> {
        viewModel?.auth()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }.do(onNext: { [weak self] in
                self?.loading.text = NSLocalizedString("loadData", comment: "")
            }) ?? Observable.empty()
    }
    /** Load data */
    private func load() -> Observable<Void> {
        viewModel?.loadComplete()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            } ?? Observable.empty()
    }
    
    

}
