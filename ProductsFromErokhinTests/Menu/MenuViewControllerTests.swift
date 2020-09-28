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
        // Delegate
        XCTAssertNotNil(groups.delegate)
        // DataSource
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
    
    func testSelectGroup() {
        let groupDataSource = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
        let productsDataSource = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
        
        // Not found Group at IndexPath & product IndexPath for Group
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        XCTAssertFalse((controller.products as! TableViewMock).isScroll)
        
        controller.groups.delegate?.collectionView?(controller.groups, didSelectItemAt: IndexPath())
        
        XCTAssertTrue((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertTrue((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        XCTAssertFalse((controller.products as! TableViewMock).isScroll)
        
        // Found Group at IndexPath but not found product IndexPath for Group
        (controller.groups as! CollectionViewMock).isScroll = false
        (controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected = false
        (controller.products as! TableViewMock).isScroll = false
        
        groupDataSource.objectResult = Group(context: context)
        
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        
        controller.groups.delegate?.collectionView?(controller.groups, didSelectItemAt: IndexPath())
        
        XCTAssertTrue((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertTrue((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        XCTAssertFalse((controller.products as! TableViewMock).isScroll)
        
        // Found Group at IndexPath & product IndexPath for Group
        (controller.groups as! CollectionViewMock).isScroll = false
        (controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected = false
        (controller.products as! TableViewMock).isScroll = false
        
        groupDataSource.objectResult = Group(context: context)
        productsDataSource.indexPathResult = IndexPath()
        
        controller.groups.delegate?.collectionView?(controller.groups, didSelectItemAt: IndexPath())
        
        XCTAssertTrue((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertTrue((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        XCTAssertTrue((controller.products as! TableViewMock).isScroll)
    }
    
    func testSelectGroupWhenScrollProducts() {
        let groupDataSource = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
        let productsDataSource = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
        
        // Not select group. productIndexPath, group, groupIndexPath not found
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        // Not select group. productIndexPath found. group, groupIndexPath not found
        (controller.products as! TableViewMock).indexPathsForVisibleRowsResult = [IndexPath()]
        
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        // Not select when product scroll by select group (tabSelected == true)
        
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
