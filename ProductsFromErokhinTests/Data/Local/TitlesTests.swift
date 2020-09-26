//
//  TitlesTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class TitlesTests: XCTestCase {

    func testUpdate() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let titlesRemote = TitlesRemote(title: "title", img: "img", imgTitle: "imgTitle", productsTitle: "productsTitle", productsTitle2: "productsTitle2")
        let order = 1
        let titles = Titles(context: context)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        titles.update(from: titlesRemote, order: order)
        XCTAssertEqual(titles.order, Int16(order))
        XCTAssertEqual(titles.title, titlesRemote.title)
        XCTAssertEqual(titles.img, titlesRemote.img)
        XCTAssertEqual(titles.imgTitle, titlesRemote.imgTitle)
        XCTAssertEqual(titles.productsTitle, titlesRemote.productsTitle)
        XCTAssertEqual(titles.productsTitle2, titlesRemote.productsTitle2)
        
        waitForExpectations(timeout: 1)
    }

}
