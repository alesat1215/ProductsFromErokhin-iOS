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
        XCTAssertNil(collectionView.cellId)
        XCTAssertEqual(collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: .init()), collectionView.cell)
        XCTAssertEqual(collectionView.cellId, "test")
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
        XCTAssertEqual(collectionView.cellForItem(at: .init()), collectionView.cell)
        // Scroll
        XCTAssertFalse(collectionView.isScroll)
        collectionView.scrollToItem(at: IndexPath(), at: .bottom, animated: true)
        XCTAssertTrue(collectionView.isScroll)
    }

}
