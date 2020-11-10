//
//  ProfileViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 09.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class ProfileViewModelMockTests: XCTestCase {
    
    private var viewModel: ProfileViewModelMock!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        viewModel = ProfileViewModelMock()
    }

    override func tearDownWithError() throws {
        try Profile.clearEntity(context: context)
    }
    
    func testProfile() {
        var result: Profile?
        viewModel.profile().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertNil(result)
        let profile = Profile(context: context)
        viewModel.profileResult.accept(profile)
        XCTAssertEqual(result, profile)
    }
    
    func testUpdateProfile() {
        XCTAssertNil(viewModel.updateProfileParamsResult)
        XCTAssertFalse(viewModel.isUpdateProfile)
        XCTAssertThrowsError(try viewModel.updateProfile(name: "name", phone: "phone", address: "address").toBlocking().first())
        XCTAssertNotNil(viewModel.updateProfileParamsResult)
        XCTAssertEqual(viewModel.updateProfileParamsResult?.name, "name")
        XCTAssertEqual(viewModel.updateProfileParamsResult?.phone, "phone")
        XCTAssertEqual(viewModel.updateProfileParamsResult?.address, "address")
        XCTAssertTrue(viewModel.isUpdateProfile)
    }

}
