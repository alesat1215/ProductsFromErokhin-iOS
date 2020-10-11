//
//  TutorialViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class TutorialViewModelTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var repository: AppRepositoryMock!
    private var userDefaults: UserDefaultsMock!
    private var viewModel: TutorialViewModel!

    override func setUpWithError() throws {
        repository = AppRepositoryMock()
        userDefaults = UserDefaultsMock()
        viewModel = TutorialViewModelImpl(repository: repository, userDefaults: userDefaults)
    }
    
    func testInstructions() {
        XCTAssertEqual(try viewModel.instructions().dematerialize().toBlocking().first(), repository.instructionsResult)
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
