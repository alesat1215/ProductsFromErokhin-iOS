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

    // MARK: - Outlets
    @IBOutlet weak var products: UICollectionView!
    @IBOutlet weak var products2: UICollectionView!
    
    var viewModel: StartViewModel! // di
    
    private let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    /** Bind data to views */
    private func bind() {
        // Shared observable with products
        let _products = viewModel.products()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .share()
        
        // Filter [Product] for products & bind
        _products.map { $0.filter { $0.inStart } }
            .debug("Products", trimOutput: true)
            .bind(to: products.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, model, cell in
                cell.name.text = model.name
        }.disposed(by: dispose)
        
        // Filter [Product] for products2 & bind
        _products.map { $0.filter { $0.inStart2 } }
            .debug("Products2", trimOutput: true)
            .bind(to: products2.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, model, cell in
                cell.name.text = model.name
        }.disposed(by: dispose)
    }

}

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
}
