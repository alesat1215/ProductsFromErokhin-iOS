//
//  StartViewControllerTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class StartViewControllerTests: XCTestCase {
    
    private var controller: StartViewController!
    private var viewModel: StartViewModelMock!
    private let context = ContextMock()
    // Outlets
    private var _title: UILabel!
    private var img: UIImageView!
    private var imgTitle: UILabel!
    private var productsTitle: UILabel!
    private var productsTitle2: UILabel!
    private var products: UICollectionView!
    private var products2: UICollectionView!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StartViewController")
        viewModel = StartViewModelMock()
        controller.viewModel = viewModel
        // Set views
        _title = UILabel()
        img = UIImageView()
        imgTitle = UILabel()
        productsTitle = UILabel()
        productsTitle2 = UILabel()
        products = CollectionViewMock()
        products2 = CollectionViewMock()
        // Set outlets
        controller._title = _title
        controller.img = img
        controller.imgTitle = imgTitle
        controller.productsTitle = productsTitle
        controller.productsTitle2 = productsTitle2
        
        controller.viewDidLoad()
    }
    
    func testBindTitles() {
        XCTAssertNil(controller._title.text)
        XCTAssertNil(controller.imgTitle.text)
        XCTAssertNil(controller.productsTitle.text)
        XCTAssertNil(controller.productsTitle2.text)
        // Setup titles
        var titles = Titles(context: context)
        titles.title = "title"
        titles.imgTitle = "imgTitle"
        titles.productsTitle = "productsTitle"
        titles.productsTitle2 = "productsTitle2"
        // Success event
        viewModel.titlesResult.accept(Event.next([titles]))
        XCTAssertEqual(controller._title.text, titles.title)
        XCTAssertEqual(controller.imgTitle.text, titles.imgTitle)
        XCTAssertEqual(controller.productsTitle.text, titles.productsTitle)
        XCTAssertEqual(controller.productsTitle2.text, titles.productsTitle2)
        
        titles = Titles(context: context)
        titles.title = "title_2"
        titles.imgTitle = "imgTitle_2"
        titles.productsTitle = "productsTitle_2"
        titles.productsTitle2 = "productsTitle2_2"
        viewModel.titlesResult.accept(Event.next([titles]))
        XCTAssertEqual(controller._title.text, titles.title)
        XCTAssertEqual(controller.imgTitle.text, titles.imgTitle)
        XCTAssertEqual(controller.productsTitle.text, titles.productsTitle)
        XCTAssertEqual(controller.productsTitle2.text, titles.productsTitle2)
        // Error event
        viewModel.titlesResult.accept(Event.error(AppError.unknown))
        XCTAssertEqual(controller._title.text, titles.title)
        XCTAssertEqual(controller.imgTitle.text, titles.imgTitle)
        XCTAssertEqual(controller.productsTitle.text, titles.productsTitle)
        XCTAssertEqual(controller.productsTitle2.text, titles.productsTitle2)
        // Success event after error
        titles = Titles(context: context)
        titles.title = "title_3"
        titles.imgTitle = "imgTitle_3"
        titles.productsTitle = "productsTitle_3"
        titles.productsTitle2 = "productsTitle2_3"
        viewModel.titlesResult.accept(Event.next([titles]))
        XCTAssertEqual(controller._title.text, titles.title)
        XCTAssertEqual(controller.imgTitle.text, titles.imgTitle)
        XCTAssertEqual(controller.productsTitle.text, titles.productsTitle)
        XCTAssertEqual(controller.productsTitle2.text, titles.productsTitle2)
    }
    
    func testBindProducts() {
        controller.products = products
        controller.products2 = products2
        XCTAssertNil(controller.products.dataSource)
        XCTAssertNil(controller.products2.dataSource)
        XCTAssertFalse((controller.products as! CollectionViewMock).isReload)
        XCTAssertFalse((controller.products2 as! CollectionViewMock).isReload)
        // Setup dataSource
        var dataSource = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        var dataSource2 = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        // Success event
        viewModel.productsResult.accept(Event.next(dataSource))
        viewModel.productsResult2.accept(Event.next(dataSource2))
        XCTAssertEqual(controller.products.dataSource as! CoreDataSource, dataSource)
        XCTAssertEqual(controller.products2.dataSource as! CoreDataSource, dataSource2)
        XCTAssertTrue((controller.products as! CollectionViewMock).isReload)
        XCTAssertTrue((controller.products2 as! CollectionViewMock).isReload)
        
        dataSource = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        dataSource2 = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        (controller.products as! CollectionViewMock).isReload = false
        (controller.products2 as! CollectionViewMock).isReload = false
        viewModel.productsResult.accept(Event.next(dataSource))
        viewModel.productsResult2.accept(Event.next(dataSource2))
        XCTAssertEqual(controller.products.dataSource as! CoreDataSource, dataSource)
        XCTAssertEqual(controller.products2.dataSource as! CoreDataSource, dataSource2)
        XCTAssertTrue((controller.products as! CollectionViewMock).isReload)
        XCTAssertTrue((controller.products2 as! CollectionViewMock).isReload)
        // Error event
        (controller.products as! CollectionViewMock).isReload = false
        (controller.products2 as! CollectionViewMock).isReload = false
        viewModel.productsResult.accept(Event.error(AppError.unknown))
        viewModel.productsResult2.accept(Event.error(AppError.unknown))
        XCTAssertEqual(controller.products.dataSource as! CoreDataSource, dataSource)
        XCTAssertEqual(controller.products2.dataSource as! CoreDataSource, dataSource2)
        XCTAssertFalse((controller.products as! CollectionViewMock).isReload)
        XCTAssertFalse((controller.products2 as! CollectionViewMock).isReload)
        // Success event after error
        dataSource = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        dataSource2 = CoreDataSourceMock(fetchRequest: Product.fetchRequestWithSort())
        (controller.products as! CollectionViewMock).isReload = false
        (controller.products2 as! CollectionViewMock).isReload = false
        viewModel.productsResult.accept(Event.next(dataSource))
        viewModel.productsResult2.accept(Event.next(dataSource2))
        XCTAssertEqual(controller.products.dataSource as! CoreDataSource, dataSource)
        XCTAssertEqual(controller.products2.dataSource as! CoreDataSource, dataSource2)
        XCTAssertTrue((controller.products as! CollectionViewMock).isReload)
        XCTAssertTrue((controller.products2 as! CollectionViewMock).isReload)
    }
    
    func testPrepare() {
        let destination = UIViewController()
        destination.view.addSubview(products)
        // products
        var segue = UIStoryboardSegue(identifier: "productsSegueId", source: UIViewController(), destination: destination)
        XCTAssertNil(controller.products)
        controller.prepare(for: segue, sender: nil)
        XCTAssertEqual(controller.products, products)
        // products2
        segue = UIStoryboardSegue(identifier: "productsSegueId2", source: UIViewController(), destination: destination)
        XCTAssertNil(controller.products2)
        controller.prepare(for: segue, sender: nil)
        XCTAssertEqual(controller.products2, products)
    }

}