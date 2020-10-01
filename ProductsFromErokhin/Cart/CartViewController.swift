//
//  CartViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 29.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class CartViewController: UIViewController {
    
    weak var products: UITableView!
    @IBOutlet weak var orderWarning: UILabel!
    @IBOutlet weak var resultSum: UILabel!
    @IBOutlet weak var send: UIButton!
    
    private let productsSegueId = "productsSegueId"
    
    var viewModel: CartViewModel? // di
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindProducts()
        bindResult()
        bindWarning()
        setupSendAction()
    }
    
    private func bindProducts() {
        // Set dataSource for products
        viewModel?.products()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .subscribe(onNext: { [weak self] in
                $0.bind(tableView: self?.products)
            }).disposed(by: disposeBag)
    }
    
    /** Set sum for order & setup send enabling */
    private func bindResult() {
        
        let totalInCart = viewModel?.totalInCart()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .share()
        
        // Set sum for order
        totalInCart?
            .map { "\($0) P" }
            .bind(to: resultSum.rx.text)
            .disposed(by: disposeBag)
        
        // Send enable
        totalInCart?
            .map { $0 > 0 }
            .bind(to: send.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindWarning() {
        // Setup visible of warning
        viewModel?.withWarning()
            .observeOn(MainScheduler.instance)
            .bind(to: orderWarning.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Set text of warning
        viewModel?.warning()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .bind(to: orderWarning.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupSendAction() {
        send.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            .flatMapLatest { [weak self] in
                self?.viewModel?.message() ?? Observable.empty()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMap { [weak self] in
                self?.rx.activity(activityItems: [$0]) ?? Observable.empty()
            }.subscribe(onNext: {
                print("Complete: \($0.0), Error: \($0.1?.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == productsSegueId {
            products = segue.destination.view as? UITableView
        }
    }

}
