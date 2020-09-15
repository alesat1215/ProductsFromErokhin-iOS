//
//  BindableCell.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 15.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import CoreData

class BindableCell<T: NSFetchRequestResult>: UICollectionViewCell {
    // IndexPath for current cell
    var indexPath: IndexPath!
    // For get model for current cell
    weak var dataSource: CoreDataSource<T>?
    /** Bind model values to views & save indexPath & dataSource. Must be ovverited in extenshion */
    func bind(model: T, indexPath: IndexPath, dataSource: CoreDataSource<T>?) {
        self.indexPath = indexPath
        self.dataSource = dataSource
    }
}
