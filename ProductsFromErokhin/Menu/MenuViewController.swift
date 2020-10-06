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
    
    private let productsSegueId = "productsSegueId"
    
    var viewModel: MenuViewModel?
    /** For check scroll by group select */
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
        groups?.rx.itemSelected.subscribe(onNext: { [weak self] in
            // Disable select group by scroll products
            self?.tabSelected = true
            // Select group
            self?.selectGroup(indexPath: $0)
            // Scroll to product from group
            if let group = (self?.groups.dataSource as? CoreDataSourceCollectionView<Group>)?.object(at: $0),
               let indexPath = (self?.products.dataSource as? CoreDataSourceTableView<Product>)?.productPositionForGroup(group: group)
            {
                self?.products.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }).disposed(by: disposeBag)
        
        // Set dataSource for groups
        viewModel?.groups()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
            .subscribe(onNext: { [weak self] in
                $0.bind(collectionView: self?.groups)
            }).disposed(by: disposeBag)
    }
    /** Setup select group when scroll & set dataSource for products */
    private func bindProducts() {
        // Select group for top visible cell of products
        products?.rx.willDisplayCell
            .throttle(RxTimeInterval.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                // Return for scrolling products by group selected
                if self?.tabSelected ?? true { return }
                // Select group
                if let productIndexPath = self?.products.indexPathsForVisibleRows?.first,
                   let group = (self?.products.dataSource as? CoreDataSourceTableView<Product>)?.object(at: productIndexPath)?.group,
                   !group.isSelected,
                   let groupIndexPath = (self?.groups.dataSource as? CoreDataSourceCollectionView<Group>)?.indexPath(for: group)
                {
                    self?.selectGroup(indexPath: groupIndexPath)
                }
            }).disposed(by: disposeBag)
        
        // Enable select group by scroll products
        products?.rx.willBeginDragging.subscribe(onNext: { [weak self] _ in
            self?.tabSelected = false
        }).disposed(by: disposeBag)
        
        // Set dataSource for products
        viewModel?.products()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .flatMapError { [weak self] in
                self?.rx.showMessage($0.localizedDescription) ?? Observable.empty()
            }
            .subscribe(onNext: { [weak self] in
                $0.bind(tableView: self?.products)
            }).disposed(by: disposeBag)
    }

    // Set otlet for products
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == productsSegueId {
            products = segue.destination.view as? UITableView
        }
    }
    
    /** Select group & scroll to it */
    private func selectGroup(indexPath: IndexPath) {
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
