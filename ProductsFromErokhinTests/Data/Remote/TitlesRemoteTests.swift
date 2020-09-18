//
//  TitlesRemoteTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class TitlesRemoteTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func testManagedObject() {
        let titlesRemote = TitlesRemote(title: "title", img: "img", imgTitle: "imgTitle", productsTitle: "productsTitle", productsTitle2: "productsTitle2")
        let titles = titlesRemote.managedObject(context: context) as! Titles
        XCTAssertEqual(titles.order, 0)
        XCTAssertEqual(titles.title, titlesRemote.title)
        XCTAssertEqual(titles.img, titlesRemote.img)
        XCTAssertEqual(titles.imgTitle, titlesRemote.imgTitle)
        XCTAssertEqual(titles.productsTitle, titlesRemote.productsTitle)
        XCTAssertEqual(titles.productsTitle2, titlesRemote.productsTitle2)
    }

}
