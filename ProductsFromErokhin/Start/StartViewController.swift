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
    
    private let productsSegueId = "productsSegueId"
    private let productsSegueId2 = "productsSegueId2"
    
    var viewModel: StartViewModel! // di
    
    private let disposeBag = DisposeBag()
    
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
            .debug("Products in start", trimOutput: true)
            .bind(to: products.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, product, cell in
                // Bind product to cell
                cell.bind(product: product)
        }.disposed(by: disposeBag)
        
        // Filter [Product] for products2 & bind
        _products.map { $0.filter { $0.inStart2 } }
            .debug("Products in start 2", trimOutput: true)
            .bind(to: products2.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, product, cell in
                // Bind product to cell
                cell.bind(product: product)
        }.disposed(by: disposeBag)
    }
    
    // Set otlets for products
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set products outlet
        if segue.identifier == productsSegueId {
            products = segue.destination.view.subviews[0] as? UICollectionView
        }
        // Set products2 outlet
        if segue.identifier == productsSegueId2 {
            products2 = segue.destination.view.subviews[0] as? UICollectionView
        }
    }
    
}

// MARK: - Cell
class ProductCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var inCart: UILabel!
}

extension ProductCell {
    /** Bind data from product to views */
    func bind(product: Product) {
        name.text = product.name
        price.text = "\(product.price) P/Kg"
        inCart.text = "\(product.inCart?.count ?? 0)"
    }
}
