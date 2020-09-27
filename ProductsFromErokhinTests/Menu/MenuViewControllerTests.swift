//
//  MenuViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 27.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class MenuViewControllerTests: XCTestCase {
    
    private var controller: MenuViewController!
    private var viewModel: MenuViewModelMock!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Outlets
    private var groups: UICollectionView!
    private var products: UITableView!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuViewController")
        viewModel = MenuViewModelMock()
        controller.viewModel = viewModel
        // Set views
        groups = CollectionViewMock()
        products = TableViewMock()
        // Set outlets
        controller.groups = groups
        controller.products = products
        
        controller.viewDidLoad()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBindGroups() {
        XCTAssertNil(controller.groups.dataSource)
        XCTAssertFalse((controller.groups as! CollectionViewMock).isReload)
        // Setup dataSource
        var dataSource = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
        // Success event
        viewModel.groupsResult.accept(Event.next(dataSource))
        XCTAssertEqual(controller.groups.dataSource as! CoreDataSourceCollectionView, dataSource)
        XCTAssertTrue((controller.groups as! CollectionViewMock).isReload)
        
        dataSource = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
        (controller.groups as! CollectionViewMock).isReload = false
        viewModel.groupsResult.accept(Event.next(dataSource))
        XCTAssertEqual(controller.groups.dataSource as! CoreDataSourceCollectionView, dataSource)
        XCTAssertTrue((controller.groups as! CollectionViewMock).isReload)
        // Error event
        (controller.groups as! CollectionViewMock).isReload = false
        viewModel.groupsResult.accept(Event.error(AppError.unknown))
        XCTAssertEqual(controller.groups.dataSource as! CoreDataSourceCollectionView, dataSource)
        XCTAssertFalse((controller.groups as! CollectionViewMock).isReload)
        // Success event after error
        dataSource = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
        (controller.groups as! CollectionViewMock).isReload = false
        viewModel.groupsResult.accept(Event.next(dataSource))
        XCTAssertEqual(controller.groups.dataSource as! CoreDataSourceCollectionView, dataSource)
        XCTAssertTrue((controller.groups as! CollectionViewMock).isReload)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
