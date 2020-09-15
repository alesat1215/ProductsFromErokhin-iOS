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
    var indexPath: IndexPath!
    weak var dataSource: CoreDataSource<Product>?
    
    func bind(model: T, indexPath: IndexPath, dataSource: CoreDataSource<T>?) {
        print("Warning! Bind for cell isn't ovverite")
    }
}
