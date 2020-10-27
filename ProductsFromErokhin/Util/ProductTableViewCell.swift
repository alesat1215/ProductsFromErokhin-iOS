//
//  ProductTableViewCell.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 21.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class ProductTableViewCell: BindableTableViewCell<Product> {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var inCart: UILabel!
    @IBOutlet weak var inCartMarker: UIView!
    @IBOutlet weak var _del: UIButton!
    /** Enable animation only for add/del from button. Not for every bind */
    private var withAnimation = false
    
    /** Add product to cart with animation */
    @IBAction func add(_ sender: UIButton) {
        // Enable animation
        withAnimation = true
        // Add product to cart
        switch model?.addToCart() {
        case .failure(let error):
            print(error.localizedDescription)
        default:
            print("Product add to cart success")
        }
    }
    /** Del product from cart with animation */
    @IBAction func del(_ sender: UIButton) {
        // Enable animation
        withAnimation = true
        // Del product from cart
        switch model?.delFromCart() {
        case .failure(let error):
            print(error.localizedDescription)
        default:
            print("Product add to cart success")
        }
    }
    
    override func bind(model: Product?) {
        name.text = model?.name
        price.text = "\(model?.price ?? 0) ₽/\(NSLocalizedString("kg", comment: ""))"
        let inCartCount = model?.inCart?.count ?? 0
        inCart.text = "\(inCartCount)"
        // Set image
        img.sd_setImage(with: storageReference(path: model?.img ?? ""))
        // Set visible of elements
        let hidden = inCartCount == 0
        if withAnimation {
            layer.removeAllAnimations()
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.setupIsHidden(hidden: hidden)
            }
        } else {
            setupIsHidden(hidden: hidden)
        }
        // Disable animation
        withAnimation = false
        super.bind(model: model)
    }
    /** Setup visibility for inCartMarker, del, inCart  */
    private func setupIsHidden(hidden: Bool) {
        inCartMarker.alpha = hidden ? 0 : 1
        _del.isHidden = hidden
        inCart.isHidden = hidden
    }
    
}
