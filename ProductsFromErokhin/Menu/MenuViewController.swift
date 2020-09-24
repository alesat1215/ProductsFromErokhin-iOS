//
//  MenuViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 02.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    /** Set delegate & dataSorce for groups */
    private func bindGroups() {
        groups.delegate = self
        viewModel?.groups()
            .flatMapError { print("Groups error: \($0.localizedDescription)") }
            .subscribe(onNext: { [weak self] in $0.bind(collectionView: self?.groups) }).disposed(by: disposeBag)
    }
    /** Setup select group when scroll & set dataSource for products */
    private func bindProducts() {
        // Select group for top visible cell of products
        products.rx.willDisplayCell
            .throttle(RxTimeInterval.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let indexPath = self?.products.indexPathsForVisibleRows?.first,
                   let group = (self?.products.dataSource as? CoreDataSourceTableView<Product>)?.object(at: indexPath)?.group,
                   !group.isSelected
                {
                    self?.selectGroup(group: group)
                }
            }).disposed(by: disposeBag)
        // Set dataSource for products
        viewModel?.products()
            .flatMapError { print("Products error: \($0.localizedDescription)") }
            .subscribe(onNext: { [weak self] in
                $0.bind(tableView: self?.products)
            }).disposed(by: disposeBag)
    }

    // Set otlets for products
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productsSegueId" {
            products = segue.destination.view as? UITableView
        }
    }
    /** Select group & scroll to it */
    private func selectGroup(group: Group) {
        if let indexPath = (groups.dataSource as? CoreDataSourceCollectionView<Group>)?.indexPath(for: group) {
            collectionView(groups, didSelectItemAt: indexPath)
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
    }
}
