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

class CoreDataSourceTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var products = [NSManagedObject]()
    private var dataSource: CoreDataSource<Product>!
    private var collectionView: CollectionViewMock!
    
    override func setUpWithError() throws {
        // Clear products
        try Product.clearEntity(context: context)
        // Add products
        products = [("product", 0), ("product2", 1), ("product3", 2)].map {
            let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
            product.setValue($0.0, forKey: "name")
            product.setValue($0.1, forKey: "order")
            return product
        }
        try context.save()
        
        dataSource = try context.rx.coreDataSource(cellId: "product", fetchRequest: Product.fetchRequestWithSort()).toBlocking().first()
        collectionView = CollectionViewMock(frame: .init(), collectionViewLayout: .init())
    }

    override func tearDownWithError() throws {
        // Clear products
        try Product.clearEntity(context: context)
        try context.save()
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
        XCTAssertTrue((cell as! CoreDataCellMock).isBind)
    }
    
    func testNSFetchedResultsControllerDelegate() {
        let fetchRequest = Product.fetchRequestWithSort() as! NSFetchRequest<NSFetchRequestResult>
        let frc: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Not bind
        dataSource.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: nil)
        XCTAssertFalse(collectionView.isInsert)
        // Bind
        dataSource.bind(collectionView: collectionView)
        // Insert
        dataSource.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: nil)
        XCTAssertFalse(collectionView.isInsert)
        dataSource.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: .init())
        XCTAssertTrue(collectionView.isInsert)
        collectionView.isInsert.toggle()
        // Update
        dataSource.controller(frc, didChange: products.first!, at: nil, for: .update, newIndexPath: nil)
        XCTAssertFalse(collectionView.cell.isBind)
        dataSource.controller(frc, didChange: products.first!, at: .init(), for: .update, newIndexPath: nil)
        XCTAssertTrue(collectionView.cell.isBind)
        collectionView.cell.isBind.toggle()
        // Move
        dataSource.controller(frc, didChange: products.first!, at: nil, for: .move, newIndexPath: nil)
        XCTAssertFalse(collectionView.isInsert)
        XCTAssertFalse(collectionView.isDelete)
        dataSource.controller(frc, didChange: products.first!, at: .init(), for: .move, newIndexPath: .init())
        XCTAssertTrue(collectionView.isInsert)
        XCTAssertTrue(collectionView.isDelete)
        collectionView.isInsert.toggle()
        collectionView.isDelete.toggle()
        // Delete
        dataSource.controller(frc, didChange: products.first!, at: nil, for: .delete, newIndexPath: nil)
        XCTAssertFalse(collectionView.isDelete)
        dataSource.controller(frc, didChange: products.first!, at: IndexPath(item: 0, section: 0), for: .delete, newIndexPath: nil)
        XCTAssertTrue(collectionView.isDelete)
        collectionView.isDelete.toggle()
    }
    
    func testObject() {
        XCTAssertEqual(dataSource.object(at: IndexPath(item: 0, section: 0)), products.first)
        XCTAssertNil(dataSource.object(at: IndexPath(item: 0, section: 7)))
        XCTAssertNil(dataSource.object(at: IndexPath(item: 5, section: 0)))
    }
    
    func testDispose() {
        dataSource.bind(collectionView: collectionView)
        XCTAssertNotNil(collectionView.dataSource)
        dataSource.dispose()
        XCTAssertNil(collectionView.dataSource)
    }

}
