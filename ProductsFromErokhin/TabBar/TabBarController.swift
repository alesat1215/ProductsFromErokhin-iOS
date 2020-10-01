//
//  TabBarController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 29.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class TabBarController: UITabBarController {

    @IBOutlet weak var clearCart: UIButton!
    
    var viewModel: TabBarViewModel? // di
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
        clearCart.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .asObservable()
            .observeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
            .compactMap { [weak self] in return self?.viewModel?.clearCart() }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .failure(let error):
                    print("Clear cart error: \(error.localizedDescription)")
                default:
                    print("Clear cart success")
                }
            }).disposed(by: disposeBag)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        clearCart.isHidden = item.tag != cartTag
    }

}
