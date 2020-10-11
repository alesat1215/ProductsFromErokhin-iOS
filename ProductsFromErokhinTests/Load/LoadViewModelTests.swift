//
//  LoadViewModelTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import FirebaseAuth
@testable import ProductsFromErokhin

class LoadViewModelTests: XCTestCase {
    
    private var viewModel: LoadViewModelImpl<AuthMock>!
    private var repository: AppRepositoryMock!
    private var auth: AuthMock!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        repository = AppRepositoryMock()
        auth = AuthMock()
        viewModel = LoadViewModelImpl(repository: repository, anonymousAuth: auth, userDefaults: nil)
    }
    
    func testAuth() {
        var result: Event<Void>?
        viewModel.auth().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertNil(result)
        auth.completion?(nil, AppError.unknown)
        XCTAssertNotNil(result)
    }
    
    func testLoadComplete() {
        // Complete
        XCTAssertTrue(try viewModel.loadComplete().toBlocking().first()?.element ?? false)
        // Uncomplete
        repository.titlesResult = []
        XCTAssertFalse(try viewModel.loadComplete().toBlocking().first()?.element ?? true)
    }

}
