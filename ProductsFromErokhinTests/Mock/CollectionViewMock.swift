//
//  CollectionViewMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class CollectionViewMock: UICollectionView {
    let cell = CoreDataCellMock()
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        cell
    }
    
    var isReload = false
    override func reloadData() {
        isReload.toggle()
    }
    
    var isInsert = false
    override func insertItems(at indexPaths: [IndexPath]) {
        isInsert.toggle()
    }
    
    var isDelete = false
    override func deleteItems(at indexPaths: [IndexPath]) {
        isDelete.toggle()
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        3
    }
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return cell
    }
}
