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
    private var repository: RepositoryMock!

    override func setUpWithError() throws {
        repository = RepositoryMock()
        viewModel = ProfileViewModelImpl(repository: repository)
    }
    
    func testProfile() {
        XCTAssertNil(try viewModel.profile().toBlocking().first())
        repository.profileResult.append(Profile(context: context))
        XCTAssertNotNil(try viewModel.profile().toBlocking().first())
    }
    
    func testUpdateProfile() {
        XCTAssertNoThrow(try viewModel.updateProfile(name: "", phone: "", address: "").get())
    }

}
