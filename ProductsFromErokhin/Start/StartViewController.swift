//
//  StartViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 02.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseUI

class StartViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var productsTitle: UILabel!
    @IBOutlet weak var productsTitle2: UILabel!
    @IBOutlet weak var products: UICollectionView!
    @IBOutlet weak var products2: UICollectionView!
    
    private let productsSegueId = "productsSegueId"
    private let productsSegueId2 = "productsSegueId2"
    
    var viewModel: StartViewModel? // di
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Bind data to views
        bindTitles()
        bindProducts()
    }
    
    /** Bind first result from request to titles */
    private func bindTitles() {
        viewModel?.titles()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .map { $0.first }
            .subscribe(onNext: { [weak self] in
                self?._title.text = $0?.title
                self?.img.sd_setImage(with: storageReference(path: $0?.img ?? ""))
                self?.imgTitle.text = $0?.imgTitle
                self?.productsTitle.text = $0?.productsTitle
                self?.productsTitle2.text = $0?.productsTitle2
            }).disposed(by: disposeBag)
    }
    
    /** Bind products & products2 UICollectionView */
    private func bindProducts() {
        // products
        viewModel?.products()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .subscribe(
                onNext: { [weak self] in
                    $0.bind(collectionView: self?.products)
            }).disposed(by: disposeBag)
        
        // products2
        viewModel?.products2()
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
