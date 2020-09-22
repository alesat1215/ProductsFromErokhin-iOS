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
    
    @IBAction func add(_ sender: UIButton) {
        switch model?.addToCart() {
        case .failure(let error):
            print(error.localizedDescription)
        default:
            print("Product add to cart success")
        }
    }
    
    @IBAction func del(_ sender: UIButton) {
        switch model?.delFromCart() {
        case .failure(let error):
            print(error.localizedDescription)
        default:
            print("Product add to cart success")
        }
    }
    
    override func bind(model: Product?) {
        name.text = model?.name
        price.text = "\(model?.price ?? 0) P/Kg"
        let inCartCount = model?.inCart?.count ?? 0
        inCart.text = "\(inCartCount)"
        // Set image
        img.sd_setImage(with: storageReference(path: model?.img ?? ""))
        // Set visible of elements
        let hidden = inCartCount == 0 ? true : false
        inCartMarker.isHidden = hidden
        _del.isHidden = hidden
        inCart.isHidden = hidden
        super.bind(model: model)
    }
    
}
