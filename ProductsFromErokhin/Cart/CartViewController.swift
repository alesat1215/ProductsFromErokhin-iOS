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
import Contacts

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
    // Set outlet for products
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == productsSegueId {
            products = segue.destination.view as? UITableView
        }
    }

}

// MARK: - Bind
extension CartViewController {
    /** Set dataSorce for products */
    private func bindProducts() {
        // Set dataSource for products
        viewModel?.products()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
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
    /** Set text & setup visible for orderWarning */
    private func bindWarning() {
        // Setup visible of warning
        viewModel?.withoutWarning()
            .observeOn(MainScheduler.instance)
            .bind(to: orderWarning.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Set text of warning
        viewModel?.warning()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
            .bind(to: orderWarning.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - Send
extension CartViewController {
    /** Create order message, select messenger, send & clear cart after */
    private func setupSendAction() {
        send.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            // Get phone for order
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .flatMapLatest { [weak self] in
                self?.phoneForOrder() ?? Observable.empty()
            }
            // Send order
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .flatMap { [weak self] in
                self?.sendOrder() ?? Observable.empty()
            }
            // Clear cart for complete
            .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .flatMap { [weak self] in
                self?.clearCart($0) ?? Observable.empty()
            }
            // Print if clean cart
            .subscribe(onNext: {
                print("Clear cart after send")
            }).disposed(by: disposeBag)
    }
    /** Get phone for order & add it to contacts if needed */
    private func phoneForOrder() -> Observable<Void> {
        // Get phone for order
        (viewModel?.phoneForOrder() ?? Observable.empty())
            .observeOn(MainScheduler.instance)
            // Show message for error
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }.observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            // Check phone in contacts
            .flatMap { [weak self] in
                self?.viewModel?.checkContact(phone: $0) ?? Observable.empty()
            }
    }
    /** Send order & return state of complete */
    private func sendOrder() -> Observable<Bool> {
        // Create message for order
        (viewModel?.message() ?? Observable.empty())
            .observeOn(MainScheduler.instance)
            // Show select messenger for send order
            .flatMap { [weak self] in
                self?.rx.activity(activityItems: [$0]) ?? Observable.empty()
            }.flatMap { [weak self] result -> Observable<Bool> in
                // For error result show alert with error
                if let error = result.1 {
                    return self?.rx.showMessage(error.localizedDescription)
                        .map { false } ?? Observable.empty()
                }
                // For success result send it status
                return Observable.just(result.0)
            }
    }
    /** Clear cart for complete */
    private func clearCart(_ complete: Bool) -> Observable<Void> {
        // Check comlete for send
        guard let viewModel = viewModel, complete else {
            return Observable.empty()
        }
        // Clear cart for complete
        return Observable.just(viewModel.clearCart())
            .observeOn(MainScheduler.instance)
            // Check result for clear cart. If need show error
            .flatMap { [weak self] result -> Observable<Void> in
                switch result {
                case .failure(let error):
                    // Show error
                    return self?.rx.showMessage(error.localizedDescription, withEvent: false) ?? Observable.empty()
                default:
                    return Observable.just(())
                }
            }
    }
}
