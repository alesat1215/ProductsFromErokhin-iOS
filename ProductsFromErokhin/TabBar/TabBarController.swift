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

        bindCartBadge()
    }
    /** Find item for cart & bind in cart count to it */
    func bindCartBadge() {
        // Find item
        guard let cartItem = tabBar.items?.first(where: { $0.tag == cartTag }) else {
            print("Cart item not found")
            return
        }
        // Bind value
        viewModel?.inCartCount()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn("")
            .bind(to: cartItem.rx.badgeValue)
            .disposed(by: disposeBag)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        clearCart.isHidden = item.tag != cartTag
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
