//
//  DatabaseUpdaterTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import FirebaseRemoteConfig
@testable import ProductsFromErokhin

class DatabaseUpdaterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // MARK: - Remote config
    func testResult() {
        let disposeBag = DisposeBag()
        let complection = RemoteConfigComplection()
        var result: (status: RemoteConfigFetchAndActivateStatus, error: Error?)?
        complection.result().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        complection.completionHandler(status: .successFetchedFromRemote, error: nil)
        XCTAssertEqual(result?.status, .successFetchedFromRemote)
        XCTAssertNil(result?.error)
        complection.completionHandler(status: .successUsingPreFetchedData, error: nil)
        XCTAssertEqual(result?.status, .successUsingPreFetchedData)
        XCTAssertNil(result?.error)
        complection.completionHandler(status: .error, error: AppError.unknown)
        XCTAssertEqual(result?.status, .error)
        XCTAssertEqual(result?.error?.localizedDescription, AppError.unknown.localizedDescription)
    }
    
    func testFetchInProcess() {
        // No queue
        var fetchLimiter = FetchLimiter(serialQueue: nil)
        XCTAssertFalse(fetchLimiter.fetchInProcess)
        fetchLimiter.fetchInProcess = true
        XCTAssertFalse(fetchLimiter.fetchInProcess)
        // With queue
        fetchLimiter = FetchLimiter(serialQueue: DispatchQueue(label: "test"))
        XCTAssertFalse(fetchLimiter.fetchInProcess)
        fetchLimiter.fetchInProcess = true
        XCTAssertTrue(fetchLimiter.fetchInProcess)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
