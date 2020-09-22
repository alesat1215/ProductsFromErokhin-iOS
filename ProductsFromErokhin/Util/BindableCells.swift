//
//  CoreDataCell.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 15.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

/** Cell with bind method for model */
class BindableTableViewCell<T: AnyObject>: UITableViewCell {
    weak var model: T?
    func bind(model: T?) {
        self.model = model
    }
}
/** Cell with bind method for model */
class BindableCollectionViewCell<T: AnyObject>: UICollectionViewCell {
    weak var model: T?
    func bind(model: T?) {
        self.model = model
    }
}
