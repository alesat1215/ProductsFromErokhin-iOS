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
        products = ["product", "product2", "product3"].map {
            let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
            product.setValue($0, forKey: "name")
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
