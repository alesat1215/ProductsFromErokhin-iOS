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
    
    var viewModel: StartViewModel? // di
    
    private let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    private func bind() {        
        viewModel?.products
            .bind(to: products.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, model, cell in
                cell.name.text = model
        }.disposed(by: dispose)
        
        viewModel?.products2
            .bind(to: products2.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, model, cell in
                cell.name.text = model
        }.disposed(by: dispose)
        
//        viewModel?.productsRemote()?
//            .subscribeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
//            .observeOn(MainScheduler.instance)
//            .subscribe(
//                onNext: {
//                    print($0.count)
//            }, onError: {
//                print($0)
//            }).disposed(by: dispose)
        
        viewModel?.groups()?.subscribe(
            onNext: {
                print("Groups \($0)")
        }, onError: {
            print($0)
        }).disposed(by: dispose)
        
        viewModel?.productsDB()?.subscribe(
            onNext: {
                print("Products \($0)")
        }, onError: {
            print($0)
        }).disposed(by: dispose)
    }

}

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
}
