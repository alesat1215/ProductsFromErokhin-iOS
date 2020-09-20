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
    private let repository = AppRepositoryMock()
    private let context = ContextMock()
    // Outlets
    private var _title: UILabel!
    private var img: UIImageView!
    private var imgTitle: UILabel!
    private var productsTitle: UILabel!
    private var productsTitle2: UILabel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StartViewController")
        controller.viewModel = StartViewModel(repository: repository)
        // Set views
        _title = UILabel()
        img = UIImageView()
        imgTitle = UILabel()
        productsTitle = UILabel()
        productsTitle2 = UILabel()
        // Set outlets
        controller._title = _title
        controller.img = img
        controller.imgTitle = imgTitle
        controller.productsTitle = productsTitle
        controller.productsTitle2 = productsTitle2
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testBindTitles() {
        controller.viewDidLoad()
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
        repository.titlesResult.accept(Event.next([titles]))
        XCTAssertEqual(controller._title.text, titles.title)
        XCTAssertEqual(controller.imgTitle.text, titles.imgTitle)
        XCTAssertEqual(controller.productsTitle.text, titles.productsTitle)
        XCTAssertEqual(controller.productsTitle2.text, titles.productsTitle2)
        titles = Titles(context: context)
        titles.title = "title_2"
        titles.imgTitle = "imgTitle_2"
        titles.productsTitle = "productsTitle_2"
        titles.productsTitle2 = "productsTitle2_2"
        repository.titlesResult.accept(Event.next([titles]))
        XCTAssertEqual(controller._title.text, titles.title)
        XCTAssertEqual(controller.imgTitle.text, titles.imgTitle)
        XCTAssertEqual(controller.productsTitle.text, titles.productsTitle)
        XCTAssertEqual(controller.productsTitle2.text, titles.productsTitle2)
        // Error event
        repository.titlesResult.accept(Event.error(AppError.unknown))
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
        repository.titlesResult.accept(Event.next([titles]))
        XCTAssertEqual(controller._title.text, titles.title)
        XCTAssertEqual(controller.imgTitle.text, titles.imgTitle)
        XCTAssertEqual(controller.productsTitle.text, titles.productsTitle)
        XCTAssertEqual(controller.productsTitle2.text, titles.productsTitle2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
