//
//  TabBarController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 29.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift
import RxUIAlert

class TabBarController: UITabBarController {

    @IBOutlet weak var clearCart: UIButton!
    
    var viewModel: CartViewModel? // di
    /** Tag for cart */
    private let cartTag = 2
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindCartCount()
        setupClearCartAction()
    }
    /** Find item for cart & bind in cart count to it. Setup enable clear cart button */
    func bindCartCount() {
        // Find tab bar item with cart
        guard let cartItem = tabBar.items?.first(where: { $0.tag == cartTag }) else {
            print("Cart item not found")
            return
        }
        
        let inCartCount = viewModel?.inCartCount()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn("")
            .share()
        
        // Bind badge value
        inCartCount?
            .bind(to: cartItem.rx.badgeValue)
            .disposed(by: disposeBag)
        
        // Clear cart enable
        inCartCount?.map { $0 != nil }
            .bind(to: clearCart.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    /** Setup action for clear cart button */
    private func setupClearCartAction() {
        clearCart?.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            .flatMapLatest { [weak self] _ in
                self?.clearCartAction() ?? Observable.empty()
            }.subscribe(onNext: {
                print("Clear cart success")
            }).disposed(by: disposeBag)
    }
    
    /** Show alert with question. For OK answer clear cart */
    private func clearCartAction() -> Observable<Void> {
        // Show question for clear cart
        rx.alert(
            title: nil, message: NSLocalizedString("clearCart", comment: ""),
            actions: [
                AlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel),
                AlertAction(title: NSLocalizedString("clear", comment: ""), type: 1, style: .destructive)
            ]
        )
        // For OK action clear cart
        .observeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
        .flatMap { [weak self] action -> Observable<Result<Void, Error>> in
            guard let viewModel = self?.viewModel, action.index == 1 else {
                return Observable.empty()
            }
            return Observable.just(viewModel.clearCart())
        }
        // Show message for clear cart error
        .observeOn(MainScheduler.instance)
        .flatMap { [weak self] result -> Observable<Void> in
            switch result {
            case .failure(let error):
                print("Clear cart error: \(error)")
                return self?.rx.showMessage(error.localizedDescription) ?? Observable.empty()
            default:
                return Observable.just(())
            }
        }
    }
    
    /** Clear cart visible only for cart controller */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        clearCart.isHidden = item.tag != cartTag
    }

}
