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
    
    private var repository: RepositoryMock!
    private var userDefaults: UserDefaultsMock!
    private var viewModel: TutorialViewModel!

    override func setUpWithError() throws {
        repository = RepositoryMock()
        userDefaults = UserDefaultsMock()
        viewModel = TutorialViewModelImpl(repository: repository, userDefaults: userDefaults)
    }
    
    func testInstructions() {
        XCTAssertEqual(try viewModel.instructions().dematerialize().toBlocking().first(), repository.instructionsResult)
    }
    
    func testReadTutorial() {
        viewModel.readTutorial()
        expectation(description: "wait 1 second").isInverted = true
        waitForExpectations(timeout: 1)
        XCTAssertTrue(userDefaults.isSet)
        XCTAssertTrue(userDefaults.setResult!)
    }

}
