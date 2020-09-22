//
//  ProductCell.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: BindableCollectionViewCell<Product> {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var inCart: UILabel!
    @IBOutlet weak var inCartMarker: UIView!
    @IBOutlet weak var _del: UIButton!
    @IBOutlet weak var img: UIImageView!
    /** Add product to cart */
    @IBAction func add(_ sender: UIButton) {
//        switch dataSource?.object(at: indexPath)?.addToCart() {
        switch model?.addToCart() {
        case .failure(let error):
            print(error.localizedDescription)
        default:
            print("Product add to cart success")
        }
    }
    /** Del product from cart */
    @IBAction func del(_ sender: UIButton) {
//        switch dataSource?.object(at: indexPath)?.delFromCart() {
        switch model?.delFromCart() {
        case .failure(let error):
            print(error.localizedDescription)
        default:
            print("Product del from cart success")
        }
    }
    
//    override func bind(model: Product, indexPath: IndexPath, dataSource: CoreDataSourceCollectionView<Product>?) {
//        // Model values to views
//        name.text = model.name
//        price.text = "\(model.price) P/Kg"
//        let inCartCount = model.inCart?.count ?? 0
//        inCart.text = "\(inCartCount)"
//        // Set image
//        img.sd_setImage(with: storageReference(path: model.img ?? ""))
//        // Set visible of elements
//        let hidden = inCartCount == 0 ? true : false
//        inCartMarker.isHidden = hidden
//        _del.isHidden = hidden
//        inCart.isHidden = hidden
//        // Set indexPath & dataSource
//        super.bind(model: model, indexPath: indexPath, dataSource: dataSource)
//    }
    
    override func bind(model: Product?) {
        // Model values to views
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
