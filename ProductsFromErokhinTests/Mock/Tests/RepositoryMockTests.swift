//
//  RepositoryMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class RepositoryMockTests: XCTestCase {
    
    private let repository = RepositoryMock()
    
    func testGroups() {
        let cellId = ["cellId"]
        XCTAssertEqual(try repository.groups(cellId: cellId).toBlocking().first()?.element, repository.groupsResult)
        XCTAssertEqual(repository.cellIdGroups, cellId)
    }

    func testTitles() {
        XCTAssertEqual(try repository.titles().toBlocking().first()?.element, repository.titlesResult)
    }
    
    func testProducts() {
        let cellId = "cellId"
        let predicate = NSPredicate()
        // CollectionView
        XCTAssertEqual(try repository.products(predicate: predicate, cellId: [cellId]).toBlocking().first()?.element, repository.productsResultCollectionView)
        XCTAssertEqual(repository.cellIdProductsCollectionView, [cellId])
        XCTAssertEqual(repository.predicateProductsCollectionView, predicate)
        // TableView
        XCTAssertEqual(try repository.products(predicate: predicate, cellId: cellId).toBlocking().first()?.element, repository.productsResultTableView)
        XCTAssertEqual(repository.cellIdProductsTableView, cellId)
        XCTAssertEqual(repository.predicateProductsTableView, predicate)
        // [Product]
        XCTAssertEqual(try repository.products(predicate: predicate).toBlocking().first(), repository.productResult)
        XCTAssertEqual(repository.predicateProducts, predicate)
    }
    
    func testClearCart() {
        XCTAssertFalse(repository.isClearCart)
        XCTAssertNoThrow(try repository.clearCart().toBlocking().first())
        XCTAssertTrue(repository.isClearCart)
    }
    
    func testOrderWarning() {
        XCTAssertEqual(try repository.orderWarning().toBlocking().first()?.element, repository.orderWarningResult)
    }
    
    func testSellerContacts() {
        XCTAssertEqual(try repository.sellerContacts().toBlocking().first()?.element, repository.sellerContactsResult)
    }
    
    func testProfile() {
        XCTAssertEqual(try repository.profile().toBlocking().first(), repository.profileResult)
    }
    
    func testUpdateProfile() {
        XCTAssertNoThrow(try repository.updateProfile(name: "", phone: "", address: "").toBlocking().first())
    }
    
    func testInstructions() {
        XCTAssertEqual(try repository.instructions().dematerialize().toBlocking().first(), repository.instructionsResult)
    }
    
    func testAboutProducts() {
        let cells = ["cell", "cell1"]
        XCTAssertTrue(repository.aboutProductsCellIdResult.isEmpty)
        XCTAssertEqual(try repository.aboutProducts(cellId: cells).dematerialize().toBlocking().first(), repository.aboutProductsResult)
        XCTAssertEqual(repository.aboutProductsCellIdResult, cells)
    }
    
    func testAboutApp() {
        XCTAssertEqual(try repository.aboutApp().dematerialize().toBlocking().first(), repository.aboutAppResult)
    }

}
