//
//  MenuViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 02.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class MenuViewController: UIViewController {
    
    @IBOutlet weak var groups: UICollectionView!
    weak var products: UITableView!
    
    var viewModel: MenuViewModel?

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindGroups()
        bindProducts()
    }
    
    private func bindGroups() {
        groups.delegate = self
        viewModel?.groups()
            .flatMapError { print("Groups error: \($0.localizedDescription)") }
            .subscribe(onNext: { [weak self] in $0.bind(collectionView: self?.groups) }).disposed(by: disposeBag)
    }
    
    private func bindProducts() {
        viewModel?.products()
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .subscribe(onNext: { [weak self] in $0.bind(tableView: self?.products) })
            .disposed(by: disposeBag)
    }

    // Set otlets for products
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productsSegueId" {
            products = segue.destination.view as? UITableView
        }
    }

}

extension MenuViewController: UICollectionViewDelegate {
    // Setup tab bar
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Scroll to the middle for selected item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        // Select group for indexPath
        switch (collectionView.dataSource as? CoreDataSourceCollectionView<Group>)?.select(indexPath: indexPath) {
        case .failure(let error):
            print("Select error: \(error)")
        default:
            print("Select group success")
        }
        
    }
}

class GroupCell: BindableCollectionViewCell<Group> {
    
    @IBOutlet weak var name: UILabel!
    
    override func bind(model: Group?) {
        name.text = model?.name
        // Setup font color for selected group
        name.isHighlighted = model?.isSelected ?? false
//        super.bind(model: model)
    }
}
