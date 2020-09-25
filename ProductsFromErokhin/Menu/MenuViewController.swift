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
    
    private var tabSelected = false

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindGroups()
        bindProducts()
    }
    
    /** Setup select & dataSorce for groups */
    private func bindGroups() {
        // Select group when item selected & scroll to it
        groups.rx.itemSelected.subscribe(onNext: { [weak self] in
//            // Scroll to the middle for selected item
//            self?.groups.scrollToItem(at: $0, at: .centeredHorizontally, animated: true)
//            // Select group for indexPath
//            switch (self?.groups.dataSource as? CoreDataSourceCollectionView<Group>)?.select(indexPath: $0) {
//            case .failure(let error):
//                print("Select error: \(error)")
//            default:
//                print("Select group success")
//            }
            self?.selectGroup(indexPath: $0)
//            if let group = (self?.groups.dataSource as? CoreDataSourceCollectionView<Group>)?.object(at: $0),
//               let indexPath = (self?.products.dataSource as? CoreDataSourceTableView<Product>)?.productPositionForGroup(group: group)
//               {
//                self?.products.scrollToRow(at: indexPath, at: .top, animated: true)
//            }
        }).disposed(by: disposeBag)
        // Set dataSource for groups
        viewModel?.groups()
            .flatMapError { print("Groups error: \($0.localizedDescription)") }
            .subscribe(onNext: { [weak self] in
                $0.bind(collectionView: self?.groups)
            }).disposed(by: disposeBag)
    }
    /** Setup select group when scroll & set dataSource for products */
    private func bindProducts() {
        // Select group for top visible cell of products
        products.rx.willDisplayCell
            .throttle(RxTimeInterval.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let productIndexPath = self?.products.indexPathsForVisibleRows?.first,
                   let group = (self?.products.dataSource as? CoreDataSourceTableView<Product>)?.object(at: productIndexPath)?.group,
                   !group.isSelected,
                   let groupIndexPath = (self?.groups.dataSource as? CoreDataSourceCollectionView<Group>)?.indexPath(for: group)
                {
                    self?.selectGroup(indexPath: groupIndexPath)
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
//    private func selectGroup(group: Group) {
//        if let indexPath = (groups.dataSource as? CoreDataSourceCollectionView<Group>)?.indexPath(for: group) {
//            groups.delegate?.collectionView?(groups, didSelectItemAt: indexPath)
//        }
//
//    }
    
    private func selectGroup(indexPath: IndexPath) {
//        if let indexPath = (groups.dataSource as? CoreDataSourceCollectionView<Group>)?.indexPath(for: group) {
//            groups.delegate?.collectionView?(groups, didSelectItemAt: indexPath)
//        }
        // Scroll to the middle for selected item
        groups.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        // Select group for indexPath
        switch (groups.dataSource as? CoreDataSourceCollectionView<Group>)?.select(indexPath: indexPath) {
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
