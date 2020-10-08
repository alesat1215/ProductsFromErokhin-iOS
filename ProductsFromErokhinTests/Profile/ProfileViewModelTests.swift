//
//  ProfileViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class ProfileViewModelTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var viewModel: ProfileViewModelImpl!
    private var repository: AppRepositoryMock!

    override func setUpWithError() throws {
        repository = AppRepositoryMock()
        viewModel = ProfileViewModelImpl(repository: repository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testProfile() {
        XCTAssertNil(try viewModel.profile().toBlocking().first())
        repository.profileResult.append(Profile(context: context))
        XCTAssertNotNil(try viewModel.profile().toBlocking().first())
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
