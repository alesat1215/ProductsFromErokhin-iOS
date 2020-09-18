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
    // Setup mocks
    class RemoteConfigComplectionMock: RemoteConfigComplection {
        var _result: (status: RemoteConfigFetchAndActivateStatus, error: Error?)?
        override func result() -> Observable<(status: RemoteConfigFetchAndActivateStatus, error: Error?)> {
            if let _result = _result {
                return Observable.just(_result)
            }
            return Observable.empty()
        }
    }
    
    class JSONDecoderMock: JSONDecoder {
        override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
            if type == [GroupRemote].self {
                return [GroupRemote(name: "", products: [])] as! T
            }
            return TitlesRemote(title: "", img: "", imgTitle: "", productsTitle: "", productsTitle2: "") as! T
        }
    }
    
    class ContextMock: NSManagedObjectContext {
        init() {
            super.init(concurrencyType: .mainQueueConcurrencyType)
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)!
            let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            persistentStoreCoordinator = storeCoordinator
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var isSaving = false
        override func save() throws {
            isSaving.toggle()
        }
        var isInsert = false
        override func insert(_ object: NSManagedObject) {
            isInsert = true
        }
        
        override var hasChanges: Bool { true }
    }
    
    // MARK: - Database
    func testSync() throws {
        // Not update. Fetch in process
        let fetchLimiter = FetchLimiter(serialQueue: DispatchQueue(label: "test"))
        fetchLimiter.fetchInProcess = true
        var databaseUpdater = DatabaseUpdater(remoteConfig: nil, remoteConfigComplection: nil, decoder: nil, context: nil, fetchLimiter: fetchLimiter)
        var sync: Observable<Event<Void>> = databaseUpdater.sync()
        XCTAssertNil(try sync.toBlocking().first())
        // Not update. successUsingPreFetchedData
        let context = ContextMock()
        fetchLimiter.fetchInProcess = false
        var complection = RemoteConfigComplectionMock()
        complection._result = (RemoteConfigFetchAndActivateStatus.successUsingPreFetchedData, nil)
        databaseUpdater = DatabaseUpdater(remoteConfig: RemoteConfig.remoteConfig(), remoteConfigComplection: complection, decoder: JSONDecoderMock(), context: context, fetchLimiter: fetchLimiter)
        sync = databaseUpdater.sync()
        XCTAssertNil(try sync.toBlocking().first())
        XCTAssertFalse(context.isSaving)
        XCTAssertFalse(context.isInsert)
        // Not update. Error
        fetchLimiter.fetchInProcess = false
        complection = RemoteConfigComplectionMock()
        complection._result = (RemoteConfigFetchAndActivateStatus.error, AppError.unknown)
        databaseUpdater = DatabaseUpdater(remoteConfig: RemoteConfig.remoteConfig(), remoteConfigComplection: complection, decoder: JSONDecoderMock(), context: context, fetchLimiter: fetchLimiter)
        sync = databaseUpdater.sync()
        XCTAssertEqual(try sync.toBlocking().first()?.error?.localizedDescription, AppError.unknown.localizedDescription)
        XCTAssertFalse(context.isSaving)
        XCTAssertFalse(context.isInsert)
        // Update
        fetchLimiter.fetchInProcess = false
        complection._result = (RemoteConfigFetchAndActivateStatus.successFetchedFromRemote, nil)
        databaseUpdater = DatabaseUpdater(remoteConfig: RemoteConfig.remoteConfig(), remoteConfigComplection: complection, decoder: JSONDecoderMock(), context: context, fetchLimiter: fetchLimiter)
        sync = databaseUpdater.sync()
        XCTAssertNil(try sync.toBlocking().first())
        XCTAssertTrue(context.isSaving)
        XCTAssertTrue(context.isInsert)
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

}
