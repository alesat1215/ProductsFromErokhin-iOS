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
import CoreData
@testable import ProductsFromErokhin

class DatabaseUpdaterTests: XCTestCase {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let disposeBag = DisposeBag()
    
    // MARK: - Database
    func testSync() throws {
        let remoteConfig = RemoteConfigMock()
        let fetchLimiter = FetchLimiter(serialQueue: DispatchQueue(label: "test"))
        let databaseUpdater = DatabaseUpdaterImpl(remoteConfig: remoteConfig, decoder: JSONDecoderMock(), context: context, fetchLimiter: fetchLimiter)
        
        // Not update. Fetch in process
        fetchLimiter.fetchInProcess = true
        XCTAssertFalse(remoteConfig.isFetchAndActivate)
        XCTAssertFalse(remoteConfig.isSubscript)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
            .isInverted = true
    
        var sync: Observable<Event<Void>> = databaseUpdater.sync()
        XCTAssertNil(try sync.toBlocking().first())
        XCTAssertFalse(remoteConfig.isFetchAndActivate)
        XCTAssertFalse(remoteConfig.isSubscript)
        XCTAssertTrue(fetchLimiter.fetchInProcess)
        
        waitForExpectations(timeout: 1)
        
        // Not update. successUsingPreFetchedData
        fetchLimiter.fetchInProcess = false
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
            .isInverted = true
        
        sync = databaseUpdater.sync()
        var result: Event<Void>?
        sync.subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertTrue(fetchLimiter.fetchInProcess)
        remoteConfig.completionHandler?(RemoteConfigFetchAndActivateStatus.successUsingPreFetchedData, nil)
        
        waitForExpectations(timeout: 1)
        XCTAssertNil(result)
        XCTAssertTrue(remoteConfig.isFetchAndActivate)
        XCTAssertFalse(remoteConfig.isSubscript)
        XCTAssertFalse(fetchLimiter.fetchInProcess)
        
        // Not update. Error
        fetchLimiter.fetchInProcess = false
        remoteConfig.isFetchAndActivate = false
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
            .isInverted = true
        sync = databaseUpdater.sync()
        sync.subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertTrue(fetchLimiter.fetchInProcess)
        remoteConfig.completionHandler?(RemoteConfigFetchAndActivateStatus.error, AppError.unknown)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(result?.error?.localizedDescription, AppError.unknown.localizedDescription)
        XCTAssertTrue(remoteConfig.isFetchAndActivate)
        XCTAssertFalse(remoteConfig.isSubscript)
        XCTAssertFalse(fetchLimiter.fetchInProcess)
        
        // Update
        fetchLimiter.fetchInProcess = false
        remoteConfig.isFetchAndActivate = false
        result = nil
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
        
        sync = databaseUpdater.sync()
        sync.subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertTrue(fetchLimiter.fetchInProcess)
        remoteConfig.completionHandler?(RemoteConfigFetchAndActivateStatus.successFetchedFromRemote, nil)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(result)
        XCTAssertTrue(remoteConfig.isFetchAndActivate)
        XCTAssertTrue(remoteConfig.isSubscript)
        XCTAssertFalse(fetchLimiter.fetchInProcess)
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

}
