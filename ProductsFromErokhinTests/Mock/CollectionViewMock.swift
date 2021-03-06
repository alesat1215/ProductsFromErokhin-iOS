//
//  CollectionViewMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class CollectionViewMock: UICollectionView {
    
    init() {
        super.init(frame: .init(), collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cell = CollectionViewCellMock()
    var cellId: String?
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        cellId = identifier
        return cell
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

    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        cell
    }
    
    var isScroll = false
    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        isScroll.toggle()
    }
}
