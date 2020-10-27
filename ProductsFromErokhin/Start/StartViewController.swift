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
    @IBOutlet weak var productsTitleContainer: ModernView!
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
        setupAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

// MARK: - Bind
extension StartViewController {
    /** Bind first result from request to titles */
    private func bindTitles() {
        viewModel?.titles()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
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
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }.subscribe(
                onNext: { [weak self] in
                    $0.bind(collectionView: self?.products)
                }).disposed(by: disposeBag)
        
        // products2
        viewModel?.products2()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }.subscribe(
                onNext: { [weak self] in
                    $0.bind(collectionView: self?.products2)
                }).disposed(by: disposeBag)
    }
}

// MARK: - Animation
extension StartViewController {
    /** Add/del animation when app foreground/background */
    func setupAnimation() {
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    /** Add animation */
    @objc private func startAnimation() {
        guard let layer = productsTitleContainer.layer as? CAGradientLayer else { return }
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        animation.fromValue = layer.colors
        animation.toValue = [layer.colors?.last, layer.colors?.last]
        animation.duration = 2
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.autoreverses = true
        layer.add(animation, forKey: "productsTitleContainer")
    }
    /** Del animation */
    @objc private func stopAnimation() {
        productsTitleContainer.layer.removeAllAnimations()
    }
}
