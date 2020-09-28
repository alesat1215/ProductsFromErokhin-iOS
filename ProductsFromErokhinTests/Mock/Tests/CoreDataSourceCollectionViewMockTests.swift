//
//  CoreDataSourceCollectionViewMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 28.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class CoreDataSourceCollectionViewMockTests: XCTestCase {

    private var dataSource: CoreDataSourceCollectionViewMock<Group>!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func setUpWithError() throws {
        dataSource = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
    }

    override func tearDownWithError() throws {
        try Group.clearEntity(context: context)
    }
    
    func testSelect() {
        XCTAssertFalse(dataSource.isSelected)
        XCTAssertNoThrow(try dataSource.select(indexPath: IndexPath()).get())
        XCTAssertTrue(dataSource.isSelected)
    }
    
    func testObject() {
        dataSource.objectResult = Group(context: context)
        XCTAssertEqual(dataSource.object(at: IndexPath()), dataSource.objectResult)
    }
    
    func testIndexPath() {
        dataSource.indexPathResult = IndexPath()
        XCTAssertEqual(dataSource.indexPath(for: Group(context: context)), dataSource.indexPathResult)
    }

}
