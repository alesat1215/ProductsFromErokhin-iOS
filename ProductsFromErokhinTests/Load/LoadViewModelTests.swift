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
import Network
@testable import ProductsFromErokhin

class LoadViewModelTests: XCTestCase {
    
    private var viewModel: LoadViewModelImpl<AuthMock, NWPathMonitorMock>!
    private var repository: RepositoryMock!
    private var auth: AuthMock!
    private var userDefaults: UserDefaultsMock!
    private var monitor: NWPathMonitorMock!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        repository = RepositoryMock()
        auth = AuthMock()
        userDefaults = UserDefaultsMock()
        monitor = NWPathMonitorMock()
        viewModel = LoadViewModelImpl(repository: repository, anonymousAuth: auth, userDefaults: userDefaults, monitor: monitor)
    }
    
    func testNWAvailable() {
        var result = false
        viewModel.nwAvailable().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertFalse(result)
        monitor.pathUpdateHandler?(NWPathMock(status: NWPath.Status.satisfied))
        XCTAssertTrue(result)
    }
    
    func testAuth() {
        var result: Event<Void>?
        viewModel.auth().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertNil(result)
        auth.completion?(nil, AppError.unknown)
        XCTAssertNotNil(result)
    }
    
    func testLoadComplete() throws {
        // Complete
        var result: Event<Void>? = try viewModel.loadComplete().toBlocking().first()
        XCTAssertNotNil(result)
        XCTAssertNil(result?.error)
        // Uncomplete
        repository.loadDataResult = Event.error(AppError.unknown)
        result = try viewModel.loadComplete().toBlocking().first()
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.error?.localizedDescription, AppError.unknown.localizedDescription)
    }
    
    func testTutorialIsRead() {
        XCTAssertEqual(viewModel.tutorialIsRead(), userDefaults.boolResult)
        XCTAssertTrue(userDefaults.isBool)
    }

}
