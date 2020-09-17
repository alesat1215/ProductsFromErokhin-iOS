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
    
    var viewModel: LoadViewModel! // di
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    /** Sign in to Firebase, load data & navigate to destination */
    private func loadData() {
        let loadComplete = viewModel.loadComplete()
        // Sign in
        viewModel.auth()
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Auth error: \($0)") }
            // Load data
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .flatMap { _ in loadComplete }
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Load error: \($0)") }
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.performSegue(withIdentifier: "toStart", sender: nil)
                    print("Load complete. Navigate to destination")
                } else { print("Load incomplete") }
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
