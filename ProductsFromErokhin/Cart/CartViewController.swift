//
//  CartViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 29.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift
import RxUIAlert

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
    
    /** Create order message, select messenger, send & clear cart after */
    private func setupSendAction() {
        send.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .flatMapLatest { [weak self] in
                // Create message for order
                self?.viewModel?.message() ?? Observable.empty()
            }
            .observeOn(MainScheduler.instance)
            .flatMap { [weak self] in
                // Show select messenger for send order
                self?.rx.activity(activityItems: [$0]) ?? Observable.empty()
            }.flatMap { [weak self] result -> Observable<Bool> in
                // For error result show alert with error
                if let error = result.1 {
                    return self?.rx.showMessage(error.localizedDescription)
                        .map { false } ?? Observable.empty()
                }
                // For success result send it status
                return Observable.just(result.0)
            }.flatMap { [weak self] result -> Observable<Void> in
                if result {
                    switch self?.viewModel?.clearCart() {
                    case .failure(let error):
                        return self?.rx.showMessage(error.localizedDescription, withEvent: false) ?? Observable.empty()
                    default:
                        return Observable.just(())
                    }
                }
                return Observable.empty()
            }.subscribe(onNext: {
                print("Clear cart after send")
            }).disposed(by: disposeBag)
//            .subscribe(onNext: { [weak self] in
//                // For success send order clear cart
//                if $0 {
//                    switch self?.viewModel?.clearCart() {
//                    case .failure(let error):
//                        print("Clear cart error: \(error)")
//                    default:
//                        print("Clear cart after send")
//                    }
//                }
//            }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == productsSegueId {
            products = segue.destination.view as? UITableView
        }
    }

}
