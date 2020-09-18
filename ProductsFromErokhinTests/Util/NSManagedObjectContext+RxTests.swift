//
//  NSManagedObjectContext+RxTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 17.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
import RxCoreData
@testable import ProductsFromErokhin

class NSManagedObjectContext_RxTests: XCTestCase {
    // Setup mocks
    class MockCell: CoreDataCell<Product> {
        var isBind = false
        override func bind(model: Product, indexPath: IndexPath, dataSource: CoreDataSource<Product>?) {
            isBind.toggle()
        }
    }
    
    class MockCollectionView: UICollectionView {
        override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
            MockCell()
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
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var products = [NSManagedObject]()
    private var dataSource: CoreDataSource<Product>!
    private var collectionView: MockCollectionView!
    
    override func setUpWithError() throws {
        try Product.clearEntity(context: context)
        products = [("product", 0), ("product2", 1), ("product3", 2)].map {
            let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
            product.setValue($0.0, forKey: "name")
            product.setValue($0.1, forKey: "order")
            return product
        }
        try context.save()
        
        dataSource = try context.rx.coreDataSource(cellId: "product", fetchRequest: Product.fetchRequestWithSort()).toBlocking().first()
        collectionView = MockCollectionView(frame: .init(), collectionViewLayout: .init())
    }

    override func tearDownWithError() throws {
        try Product.clearEntity(context: context)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCoreDataSource() throws {
        XCTAssertNotNil(dataSource)
    }
    
    func testBind() {
        XCTAssertNil(collectionView.dataSource)
        XCTAssertFalse(collectionView.isReload)
        dataSource.bind(collectionView: collectionView)
        XCTAssertNotNil(collectionView.dataSource)
        XCTAssertTrue(collectionView.isReload)
    }
    
    func testUICollectionViewDataSource() {
        // Count of items
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), products.count)
        // Cell for indexPath
        let cell = dataSource.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        XCTAssertTrue((cell as! MockCell).isBind)
    }
    
    func testNSFetchedResultsControllerDelegate() {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
