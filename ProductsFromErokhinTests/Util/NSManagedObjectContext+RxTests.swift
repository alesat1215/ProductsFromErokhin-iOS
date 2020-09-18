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
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var products = [NSManagedObject]()
    private var dataSource: CoreDataSource<Product>!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try Product.clearEntity(context: context)
        products = [("product", 0), ("product2", 1), ("product3", 2)].map {
            let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
            product.setValue($0.0, forKey: "name")
            product.setValue($0.1, forKey: "order")
            return product
        }
        try context.save()
        
        dataSource = try context.rx.coreDataSource(cellId: "product", fetchRequest: Product.fetchRequestWithSort()).toBlocking().first()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        class MockCollectionView: UICollectionView {
            var isReload = false
            override func reloadData() {
                isReload.toggle()
            }
        }
        let collectionView = MockCollectionView(frame: .init(), collectionViewLayout: .init())
        XCTAssertNil(collectionView.dataSource)
        XCTAssertFalse(collectionView.isReload)
        dataSource.bind(collectionView: collectionView)
        XCTAssertNotNil(collectionView.dataSource)
        XCTAssertTrue(collectionView.isReload)
    }
    
    func testUICollectionViewDataSource() {
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
        }
        let collectionView = MockCollectionView(frame: .init(), collectionViewLayout: .init())
        // Count of items
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), products.count)
        // Cell for indexPath
        let cell = dataSource.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        XCTAssertTrue((cell as! MockCell).isBind)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
