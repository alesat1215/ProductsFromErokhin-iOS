//
//  CartViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class CartViewModelTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var repository: AppRepositoryMock!
    private var viewModel: CartViewModel!
    private var products = [Product]()

    override func setUpWithError() throws {
        // Product with sum 10 * 1
        let product1 = { () -> Product in
            let product = Product(context: self.context)
            product.name = "product1"
            product.price = 10
            _ = product.addToCart()
            return product
        }()
        // Product with sum 10 * 2
        let product2 = { () -> Product in
            let product = Product(context: self.context)
            product.name = "product2"
            product.price = 10
            _ = product.addToCart()
            _ = product.addToCart()
            return product
        }()
        // Product with sum 10 * 3
        let product3 = { () -> Product in
            let product = Product(context: self.context)
            product.name = "product2"
            product.price = 10
            _ = product.addToCart()
            _ = product.addToCart()
            _ = product.addToCart()
            return product
        }()
        // Products with total sum == 60
        products = [product1, product2, product3]
        
        repository = AppRepositoryMock()
        repository.productResult = products
        
        viewModel = CartViewModel(repository: repository, contactStore: CNContactStoreMock())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testProducts() {
        XCTAssertNil(repository.predicateProductsTableView)
        XCTAssertNil(repository.cellIdProductsTableView)
        XCTAssertEqual(try viewModel.products().toBlocking().first()?.element, repository.productsResultTableView)
        XCTAssertNotNil(repository.predicateProductsTableView)
        XCTAssertNotNil(repository.cellIdProductsTableView)
    }
    
    func testTotalInCart() {
        XCTAssertEqual(try viewModel.totalInCart().toBlocking().first(), 60)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
