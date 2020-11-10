//
//  AboutProductsViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 13.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class AboutProductsViewController: UIViewController {

    @IBOutlet weak var aboutProducts: UICollectionView!
    
    var viewModel: AboutProductsViewModel? // di
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindAboutProducts()
    }
    
    private func bindAboutProducts() {
        viewModel?.aboutProducts()
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
            .subscribe(onNext: { [weak self] in
                $0.bind(collectionView: self?.aboutProducts)
            }).disposed(by: disposeBag)
    }

}

/** Cell for dataSource without image */
class AboutProductsCell0: BindableCollectionViewCell<AboutProducts> {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var text: UILabel!
    override func bind(model: AboutProducts?) {
        title.text = model?.title
        text.text = model?.text
    }
}
/** Cell for dataSource with image */
class AboutProductsCell1: BindableCollectionViewCell<AboutProducts> {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var text: UILabel!
    override func bind(model: AboutProducts?) {
        img.sd_setImage(with: storageReference(path: model?.img ?? ""))
        text.text = model?.text
    }
}
