//
//  RemoteConfigRepository.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift
import RxRelay
import CoreData

class RemoteConfigRepository {
    let remoteConfig: RemoteConfig? // di
    private let remoteConfigComplection: RemoteConfigComplection? // di
    private let decoder = JSONDecoder()
    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    private let fetchLimiter = FetchLimiter(serialQueue: DispatchQueue(label: "serialQueue"))
    
    init(remoteConfig: RemoteConfig?,
         remoteConfigComplection: RemoteConfigComplection?) {
        self.remoteConfig = remoteConfig
        self.remoteConfigComplection = remoteConfigComplection
    }
    
    func fetchAndActivate<T>() -> Observable<Result<T, Error>> {
        if fetchLimiter.fetchInProcess {
            return Observable.empty()
        }
        fetchLimiter.fetchInProcess = true
        remoteConfig?.fetchAndActivate(completionHandler: remoteConfigComplection?.completionHandler(status:error:))
        return remoteConfigComplection!.result().flatMap { [weak self] result -> Observable<Result<T, Error>> in
            switch result {
            case .failure(let error):
                return Observable.just(Result.failure(error))
            default:
                try self?.updateDB()
                self?.fetchLimiter.fetchInProcess = false
                return Observable.empty()
            }
        }
    }
    
    private func updateDB() throws {
        let groups: [GroupRemote] = try remoteData(key: "products")
        
        try Group.clearEntity(context: context)
        
        var productOrder = 0
        groups.enumerated().forEach {
            context.insert($1.managedObject(context: context, groupOrder: $0, productOrder: &productOrder))
        }
        
        if context.hasChanges {
            try context.save()
        }
    }
        
    private func remoteData<T: Codable>(key: String) throws -> T {
        try decoder.decode(T.self, from: remoteConfig![key].dataValue)
    }
    
}

class RemoteConfigComplection {
    private let _result = PublishRelay<Result<Void, Error>>()
    
    func completionHandler(status: RemoteConfigFetchAndActivateStatus, error: Error?) -> Void {
        switch status {
        case .error:
            let error = error ?? AppError.unknown
            _result.accept(.failure(error))
            print("Remote config fetch error: \(error.localizedDescription)")
        case .successFetchedFromRemote:
            _result.accept(.success(()))
            print("Remote config fetched data from remote")
        case .successUsingPreFetchedData:
            print("Remote config using prefetched data")
        @unknown default:
            print("Remote config unknown status")
        }
    }
    
    func result() -> Observable<Result<Void, Error>> {
        _result.asObservable()
    }
}

class FetchLimiter {
    private var _fetchInProcess = false
    private let serialQueue: DispatchQueue?
    
    init(serialQueue: DispatchQueue?) {
        self.serialQueue = serialQueue
    }
    
    var fetchInProcess: Bool {
        get {
            return serialQueue?.sync { _fetchInProcess } ?? false
        }
        set {
            serialQueue?.sync { _fetchInProcess = newValue }
        }
    }
}

extension AppError {
    static let unknown: AppError = .error("unknown")
}
