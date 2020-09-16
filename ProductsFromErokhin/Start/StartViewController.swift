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
import CoreData

class StartViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var productsTitle: UILabel!
    @IBOutlet weak var productsTitle2: UILabel!
    @IBOutlet weak var products: UICollectionView!
    @IBOutlet weak var products2: UICollectionView!
    
    private let productsSegueId = "productsSegueId"
    private let productsSegueId2 = "productsSegueId2"
    
    var viewModel: StartViewModel! // di
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Bind data to views
        bindTitles()
        bindProducts()
    }
    
    /** Bind first result from request to titles */
    private func bindTitles() {
        viewModel.titles()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .map { $0.first }
            .subscribe(onNext: { [weak self] in
                self?._title.text = $0?.title
                self?.imgTitle.text = $0?.imgTitle
                self?.productsTitle.text = $0?.productsTitle
                self?.productsTitle2.text = $0?.productsTitle2
            }).disposed(by: disposeBag)
    }
    
    /** Bind products & products2 UICollectionView */
    private func bindProducts() {
        // products
        viewModel.products()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .subscribe(
                onNext: { [weak self] in
                    $0.bind(collectionView: self?.products)
            }).disposed(by: disposeBag)
        
        // products2
        viewModel.products2()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .subscribe(
                onNext: { [weak self] in
                    $0.bind(collectionView: self?.products2)
            }).disposed(by: disposeBag)
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
class ProductCell: CoreDataCell<Product> {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var inCart: UILabel!
    @IBOutlet weak var inCartMarker: UIView!
    @IBOutlet weak var _del: UIButton!
    /** Add product to cart */
    @IBAction func add(_ sender: UIButton) {
        switch dataSource?.object(at: indexPath).addToCart() {
        case .failure(let error):
            print(error.localizedDescription)
        default:
            print("Product add to cart success")
        }
    }
    /** Del product from cart */
    @IBAction func del(_ sender: UIButton) {
        switch dataSource?.object(at: indexPath).delFromCart() {
        case .failure(let error):
            print(error.localizedDescription)
        default:
            print("Product del from cart success")
        }
    }
    
    override func bind(model: Product, indexPath: IndexPath, dataSource: CoreDataSource<Product>?) {
        // Model values to views
        name.text = model.name
        price.text = "\(model.price) P/Kg"
        let inCartCount = model.inCart?.count ?? 0
        inCart.text = "\(inCartCount)"
        // Set visible of elements
        let hidden = inCartCount == 0 ? true : false
        inCartMarker.isHidden = hidden
        _del.isHidden = hidden
        inCart.isHidden = hidden
        // Set indexPath & dataSource
        super.bind(model: model, indexPath: indexPath, dataSource: dataSource)
    }
}
