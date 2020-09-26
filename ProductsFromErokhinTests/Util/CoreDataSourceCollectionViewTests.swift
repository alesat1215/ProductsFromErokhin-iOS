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
    private var groups = [Group]()
    private var dataSourceProducts: CoreDataSourceCollectionView<Product>!
    private var dataSourceGroups: CoreDataSourceCollectionView<Group>!
    private var collectionView: CollectionViewMock!
    
    override func setUpWithError() throws {
        // Add products to context
        products = ["product", "product1", "product2"].enumerated().map {
            let product = Product(context: context)
            product.order = Int16($0.offset)
            product.name = $0.element
            return product
        }
        
        groups = ["group", "group1", "group2"].enumerated().map {
            let group = Group(context: context)
            group.order = Int16($0.offset)
            group.name = $0.element
            return group
        }
        
        dataSourceProducts = try context.rx.coreDataSource(cellId: "", fetchRequest: Product.fetchRequestWithSort()).toBlocking().first()
        dataSourceGroups = try context.rx.coreDataSource(cellId: "", fetchRequest: Group.fetchRequestWithSort()).toBlocking().first()
        collectionView = CollectionViewMock()
    }
    
    override func tearDownWithError() throws {
        try Group.clearEntity(context: context)
        try Product.clearEntity(context: context)
    }
    
    func testCoreDataSource() throws {
        XCTAssertNotNil(dataSourceProducts)
        XCTAssertNotNil(dataSourceGroups)
    }
    
    func testBind() {
        XCTAssertNil(collectionView.dataSource)
        XCTAssertFalse(collectionView.isReload)
        dataSourceProducts.bind(collectionView: collectionView)
        XCTAssertNotNil(collectionView.dataSource)
        XCTAssertTrue(collectionView.isReload)
    }
    
    func testUICollectionViewDataSource() {
        // Count of items
        XCTAssertEqual(dataSourceProducts.collectionView(collectionView, numberOfItemsInSection: 0), products.count)
        // Cell for indexPath
        let cell = dataSourceProducts.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        XCTAssertTrue((cell as! CollectionViewCellMock).isBind)
    }
    
    func testNSFetchedResultsControllerDelegate() {
        let fetchRequest = Product.fetchRequestWithSort() as! NSFetchRequest<NSFetchRequestResult>
        let frc: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Not bind
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: nil)
        XCTAssertFalse(collectionView.isInsert)
        // Bind
        dataSourceProducts.bind(collectionView: collectionView)
        // Insert
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: nil)
        XCTAssertFalse(collectionView.isInsert)
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .insert, newIndexPath: .init())
        XCTAssertTrue(collectionView.isInsert)
        collectionView.isInsert.toggle()
        // Update
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .update, newIndexPath: nil)
        XCTAssertFalse(collectionView.cell.isBind)
        dataSourceProducts.controller(frc, didChange: products.first!, at: .init(), for: .update, newIndexPath: nil)
        XCTAssertTrue(collectionView.cell.isBind)
        collectionView.cell.isBind.toggle()
        // Move
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .move, newIndexPath: nil)
        XCTAssertFalse(collectionView.isInsert)
        XCTAssertFalse(collectionView.isDelete)
        dataSourceProducts.controller(frc, didChange: products.first!, at: .init(), for: .move, newIndexPath: .init())
        XCTAssertTrue(collectionView.isInsert)
        XCTAssertTrue(collectionView.isDelete)
        collectionView.isInsert.toggle()
        collectionView.isDelete.toggle()
        // Delete
        dataSourceProducts.controller(frc, didChange: products.first!, at: nil, for: .delete, newIndexPath: nil)
        XCTAssertFalse(collectionView.isDelete)
        dataSourceProducts.controller(frc, didChange: products.first!, at: IndexPath(item: 0, section: 0), for: .delete, newIndexPath: nil)
        XCTAssertTrue(collectionView.isDelete)
        collectionView.isDelete.toggle()
    }
    
    func testObject() {
        XCTAssertEqual(dataSourceProducts.object(at: IndexPath(item: 0, section: 0)), products.first!)
        XCTAssertNil(dataSourceProducts.object(at: IndexPath(item: 0, section: 7)))
        XCTAssertNil(dataSourceProducts.object(at: IndexPath(item: 5, section: 0)))
    }
    
    func testIndexPath() {
        XCTAssertNotNil(dataSourceProducts.indexPath(for: products.first!))
        XCTAssertNil(dataSourceProducts.indexPath(for: Product(context: context)))
    }
    
    func testSelect() throws {
        groups.first?.isSelected = true
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        
        XCTAssertNoThrow(try dataSourceGroups.select(indexPath: IndexPath(item: 1, section: 0)).get())
        
        XCTAssertFalse(groups.first!.isSelected)
        XCTAssertTrue(groups[1].isSelected)
        
        waitForExpectations(timeout: 1)
    }
    
    func testDispose() {
        dataSourceProducts.bind(collectionView: collectionView)
        XCTAssertNotNil(collectionView.dataSource)
        dataSourceProducts.dispose()
        XCTAssertNil(collectionView.dataSource)
    }

}
