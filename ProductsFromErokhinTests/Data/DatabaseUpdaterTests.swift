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
    // MARK: - Database
    func testSync() throws {
//        // Not update. Fetch in process
//        let fetchLimiter = FetchLimiter(serialQueue: DispatchQueue(label: "test"))
//        fetchLimiter.fetchInProcess = true
//        var databaseUpdater = DatabaseUpdater(remoteConfig: nil, decoder: nil, context: nil, fetchLimiter: fetchLimiter)
//        var sync: Observable<Event<Void>> = databaseUpdater.sync()
//        XCTAssertNil(try sync.toBlocking().first())
//        // Not update. successUsingPreFetchedData
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        fetchLimiter.fetchInProcess = false
//        var complection = RemoteConfigComplectionMock()
//        complection._result = (RemoteConfigFetchAndActivateStatus.successUsingPreFetchedData, nil)
//        databaseUpdater = DatabaseUpdater(remoteConfig: RemoteConfig.remoteConfig(), remoteConfigComplection: complection, decoder: JSONDecoderMock(), context: context, fetchLimiter: fetchLimiter)
//        sync = databaseUpdater.sync()
//        
//        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
//        
//        XCTAssertNil(try sync.toBlocking().first())
//        
//        waitForExpectations(timeout: 1)
//        
//        // Not update. Error
//        fetchLimiter.fetchInProcess = false
//        complection = RemoteConfigComplectionMock()
//        complection._result = (RemoteConfigFetchAndActivateStatus.error, AppError.unknown)
//        databaseUpdater = DatabaseUpdater(remoteConfig: RemoteConfig.remoteConfig(), remoteConfigComplection: complection, decoder: JSONDecoderMock(), context: context, fetchLimiter: fetchLimiter)
//        sync = databaseUpdater.sync()
//        
//        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
//        
//        XCTAssertEqual(try sync.toBlocking().first()?.error?.localizedDescription, AppError.unknown.localizedDescription)
//        
//        waitForExpectations(timeout: 1)
//        
//        // Update
//        fetchLimiter.fetchInProcess = false
//        complection._result = (RemoteConfigFetchAndActivateStatus.successFetchedFromRemote, nil)
//        databaseUpdater = DatabaseUpdater(remoteConfig: RemoteConfig.remoteConfig(), remoteConfigComplection: complection, decoder: JSONDecoderMock(), context: context, fetchLimiter: fetchLimiter)
//        sync = databaseUpdater.sync()
//        
//        expectation(forNotification: .NSManagedObjectContextDidSave, object: context)
//        
//        XCTAssertNil(try sync.toBlocking().first())
//        
//        waitForExpectations(timeout: 1)
    }
    
    // MARK: - Remote config
//    func testResult() {
//        let disposeBag = DisposeBag()
//        let complection = RemoteConfigComplection()
//        var result: (status: RemoteConfigFetchAndActivateStatus, error: Error?)?
//        complection.result().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
//        complection.completionHandler(status: .successFetchedFromRemote, error: nil)
//        XCTAssertEqual(result?.status, .successFetchedFromRemote)
//        XCTAssertNil(result?.error)
//        complection.completionHandler(status: .successUsingPreFetchedData, error: nil)
//        XCTAssertEqual(result?.status, .successUsingPreFetchedData)
//        XCTAssertNil(result?.error)
//        complection.completionHandler(status: .error, error: AppError.unknown)
//        XCTAssertEqual(result?.status, .error)
//        XCTAssertEqual(result?.error?.localizedDescription, AppError.unknown.localizedDescription)
//    }
    
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
