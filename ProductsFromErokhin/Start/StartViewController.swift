//
//  StartViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 02.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StartViewController: UIViewController {

    @IBOutlet weak var products: UICollectionView!
    @IBOutlet weak var products2: UICollectionView!
    private let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    private func bind() {
        let data = Observable.just(["Product1", "Product2", "Product3", "Product4"])
        data.bind(to: products.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, model, cell in
            cell.name.text = model
        }.disposed(by: dispose)
        
        let data2 = Observable.just(["Product5", "Product6", "Product7", "Product8"])
        data2.bind(to: products2.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, model, cell in
            cell.name.text = model
        }.disposed(by: dispose)
    }

}

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
}
