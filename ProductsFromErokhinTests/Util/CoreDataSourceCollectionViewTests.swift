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

class CoreDataSourceCollectionViewTests: XCTestCase {
        
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var products = [Product]()
    private var dataSource: CoreDataSourceCollectionView<Product>!
    private var collectionView: CollectionViewMock!
    
    override func setUpWithError() throws {
        // Add products to context
        let product = Product(context: context)
        product.order = 0
        let product1 = Product(context: context)
        product1.order = 1
        let product2 = Product(context: context)
        product2.order = 2
        products = [product, product1, product2]
        
        dataSource = try context.rx.coreDataSource(cellId: "", fetchRequest: Product.fetchRequestWithSort()).toBlocking().first()
        collectionView = CollectionViewMock()
    }
    
    override func tearDownWithError() throws {
        try Group.clearEntity(context: context)
        try Product.clearEntity(context: context)
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
        XCTAssertTrue((cell as! CollectionViewCellMock).isBind)
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
        XCTAssertEqual(dataSource.object(at: IndexPath(item: 0, section: 0)), products.first!)
        XCTAssertNil(dataSource.object(at: IndexPath(item: 0, section: 7)))
        XCTAssertNil(dataSource.object(at: IndexPath(item: 5, section: 0)))
    }
    
    func testIndexPath() {
        XCTAssertNotNil(dataSource.indexPath(for: products.first!))
        XCTAssertNil(dataSource.indexPath(for: Product(context: context)))
    }
    
    func testSelect() throws {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let group = Group(context: context)
        group.order = 0
        group.isSelected = true
        let group1 = Group(context: context)
        group1.order = 1
        let group2 = Group(context: context)
        group2.order = 2
        
        let dataSource: CoreDataSourceCollectionView<Group> = try context.rx.coreDataSource(cellId: "group", fetchRequest: Group.fetchRequestWithSort()).toBlocking().first()!
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        
        XCTAssertNoThrow(try dataSource.select(indexPath: IndexPath(item: 1, section: 0)).get())
        
        XCTAssertFalse(group.isSelected)
        XCTAssertTrue(group1.isSelected)
        
        waitForExpectations(timeout: 1)
    }
    
    func testDispose() {
        dataSource.bind(collectionView: collectionView)
        XCTAssertNotNil(collectionView.dataSource)
        dataSource.dispose()
        XCTAssertNil(collectionView.dataSource)
    }

}
