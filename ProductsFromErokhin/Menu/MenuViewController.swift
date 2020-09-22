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
    
    weak var products: UITableView!
    var viewModel: MenuViewModel?
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindProducts()
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

