//
//  CoreDataCell.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 15.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import CoreData
/** Cell with bind method for CoreDataSource */
class CoreDataCell<T: NSFetchRequestResult>: UICollectionViewCell {
    // IndexPath for current cell
    var indexPath: IndexPath!
    // For get model for current cell
    weak var dataSource: CoreDataSourceCollectionView<T>?
    /** Bind model values to views & save indexPath & dataSource. Must be ovverited in extenshion */
    func bind(model: T, indexPath: IndexPath, dataSource: CoreDataSourceCollectionView<T>?) {
        self.indexPath = indexPath
        self.dataSource = dataSource
    }
}

class BindableTableViewCell<T: NSFetchRequestResult>: UITableViewCell {
    weak var model: T?
    func bind(model: T?) {
        self.model = model
    }
}

class BindableCollectionViewCell<T: NSFetchRequestResult>: UICollectionViewCell {
    weak var model: T?
    func bind(model: T?) {
        self.model = model
    }
}

//protocol BindableCell {
//    associatedtype T
//    var model: T? { get set }
//    func bind(model: T?)
//}
