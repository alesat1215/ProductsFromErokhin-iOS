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
    private var navigationController: UINavigationController!
    // Outlets
    private var groups: UICollectionView!
    private var products: UITableView!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuViewController")
        
        // Set views
        groups = CollectionViewMock()
        products = TableViewMock()
        
        navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        // Set viewModel & outlets
        viewModel = MenuViewModelMock()
        controller.viewModel = viewModel
        controller.groups = groups
        controller.products = products
        
        controller.viewDidLoad()
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
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        // Not select group. productIndexPath found. group, groupIndexPath not found
        (controller.products as! TableViewMock).indexPathsForVisibleRowsResult = [IndexPath()]
        
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        // Not select group. productIndexPath found, group found but already selected
        (controller.products as! TableViewMock).indexPathsForVisibleRowsResult = [IndexPath()]
        let product = Product(context: context)
        product.group = Group(context: context)
        product.group?.isSelected = true
        productsDataSource.objectResult = product
        
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        // Not select group. productIndexPath found, group found, group not selected, but groupIndexPath not found
        (controller.products as! TableViewMock).indexPathsForVisibleRowsResult = [IndexPath()]
        product.group?.isSelected = false
        productsDataSource.objectResult = product
        
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        // Select group. productIndexPath found, group found, group not selected, groupIndexPath found
        (controller.products as! TableViewMock).indexPathsForVisibleRowsResult = [IndexPath()]
        product.group = Group(context: context)
        product.group?.isSelected = false
        productsDataSource.objectResult = product
        groupDataSource.objectResult = product.group
        groupDataSource.indexPathResult = IndexPath()
        
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertTrue((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertTrue((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        // Not select when product scroll by select group (tabSelected == true)
        (controller.products as! TableViewMock).indexPathsForVisibleRowsResult = [IndexPath()]
        product.group = Group(context: context)
        product.group?.isSelected = false
        productsDataSource.objectResult = product
        groupDataSource.objectResult = product.group
        groupDataSource.indexPathResult = IndexPath()
        
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        
        controller.groups.delegate?.collectionView?(controller.groups, didSelectItemAt: IndexPath())
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        (controller.groups as! CollectionViewMock).isScroll = false
        (controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected = false
        
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
    }
    
    func testEnableSelectGroupByScroll() {
        let groupDataSource = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
        let productsDataSource = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
        let product = Product(context: context)
        
        // Not select when product scroll by select group (tabSelected == true)
        (controller.products as! TableViewMock).indexPathsForVisibleRowsResult = [IndexPath()]
        product.group = Group(context: context)
        product.group?.isSelected = false
        productsDataSource.objectResult = product
        groupDataSource.objectResult = product.group
        groupDataSource.indexPathResult = IndexPath()
        
        viewModel.groupsResult.accept(Event.next(groupDataSource))
        viewModel.productsResult.accept(Event.next(productsDataSource))
        
        // Disable select group by scroll products
        controller.groups.delegate?.collectionView?(controller.groups, didSelectItemAt: IndexPath())
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        (controller.groups as! CollectionViewMock).isScroll = false
        (controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected = false
        // Scroll
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertFalse((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
        
        // Enable select group by scroll products
        controller.products.delegate?.scrollViewWillBeginDragging?(controller.products)
        
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        // Scroll
        controller.products.delegate?.tableView?(controller.products, willDisplay: TableViewCellMock(), forRowAt: IndexPath())
        
        XCTAssertTrue((controller.groups as! CollectionViewMock).isScroll)
        XCTAssertTrue((controller.groups.dataSource as! CoreDataSourceCollectionViewMock<Group>).isSelected)
    }

}
