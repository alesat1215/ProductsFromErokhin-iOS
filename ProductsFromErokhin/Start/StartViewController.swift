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
    
    private func bind() {        
        viewModel.products
            .bind(to: products.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, model, cell in
                cell.name.text = model
        }.disposed(by: dispose)
        
        viewModel.products2
            .bind(to: products2.rx.items(cellIdentifier: "product", cellType: ProductCell.self)) { index, model, cell in
                cell.name.text = model
        }.disposed(by: dispose)
                
//        viewModel.groups()
//            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
//            .observeOn(MainScheduler.instance)
//            .subscribe(
//                onNext: {
//                    switch $0 {
//                    case .success(let groups):
//                        print("Groups \(groups.count)")
//                    case .failure(let error):
//                        print("Groups error \(error.localizedDescription)")
//                    }
//            }, onError: {
//                print($0)
//            }).disposed(by: dispose)
        
        catchErrorInEvent(viewModel.groups())
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {
                    print("Groups: \($0.count)")
            }, onError: {
                print($0)
            }).disposed(by: dispose)
        
        catchErrorInEvent(viewModel.productsDB())
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {
                    print("Products: \($0.count)")
            }, onError: {
                print($0)
            }).disposed(by: dispose)
        
//        viewModel.productsDB()
//            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
//            .observeOn(MainScheduler.instance)
//            .subscribe(
//                onNext: {
//                    switch $0 {
//                    case .success(let products):
//                        print("Products \(products.count)")
//                    case .failure(let error):
//                        print("Products error \(error.localizedDescription)")
//                    }
//            }, onError: {
//                print($0)
//            }).disposed(by: dispose)
    }
    
    private func catchErrorInEvent<T>(_ observable: Observable<Event<T>>) -> Observable<T> {
        observable.flatMap { event -> Observable<T> in
            switch event {
            case .error(let error):
                print("Event with error: \(error.localizedDescription)")
                return Observable.empty()
            case .next(let element):
                return Observable.just(element)
            default:
                return Observable.empty()
            }
        }
    }

}

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
}
