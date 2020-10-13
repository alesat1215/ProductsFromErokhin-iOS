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

        // Do any additional setup after loading the view.
        setupAboutProducts()
        bindAboutProducts()
    }
    
    private func setupAboutProducts() {
        aboutProducts.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else { return }
                if indexPath.section == 0 {
                    cell.frame.size.width = self.aboutProducts.frame.width
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindAboutProducts() {
        viewModel?.aboutProducts()
            .subscribeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
            .subscribe(onNext: { [weak self] in
                $0.bind(collectionView: self?.aboutProducts)
            }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class AboutProductsCell0: BindableCollectionViewCell<AboutProducts> {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var text: UILabel!
    override func bind(model: AboutProducts?) {
        title.text = model?.title
        text.text = model?.text
    }
}

class AboutProductsCell1: BindableCollectionViewCell<AboutProducts> {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var text: UILabel!
    override func bind(model: AboutProducts?) {
        img.sd_setImage(with: storageReference(path: model?.img ?? ""))
        text.text = model?.text
    }
}
