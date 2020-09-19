//
//  CollectionViewMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class CollectionViewMockTests: XCTestCase {

    func testCollectionViewMock() {
        let collectionView = CollectionViewMock()
        // Cell
        XCTAssertEqual(collectionView.dequeueReusableCell(withReuseIdentifier: "", for: .init()), collectionView.cell)
        // Reload
        XCTAssertFalse(collectionView.isReload)
        collectionView.reloadData()
        XCTAssertTrue(collectionView.isReload)
        // Insert
        XCTAssertFalse(collectionView.isInsert)
        collectionView.insertItems(at: [])
        XCTAssertTrue(collectionView.isInsert)
        // Delete
        XCTAssertFalse(collectionView.isDelete)
        collectionView.deleteItems(at: [])
        XCTAssertTrue(collectionView.isDelete)
        // Items
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), collectionView.count)
        XCTAssertEqual(collectionView.cellForItem(at: .init()), collectionView.cell)
    }

}