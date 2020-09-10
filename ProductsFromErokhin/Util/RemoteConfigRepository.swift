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
    private let remoteConfig: RemoteConfig! // di
    private let remoteConfigComplection: RemoteConfigComplection! // di
    private let decoder: JSONDecoder! // di
    private let context: NSManagedObjectContext! // di
    private let fetchLimiter: FetchLimiter! // di
    
    init(
        remoteConfig: RemoteConfig?,
        remoteConfigComplection: RemoteConfigComplection?,
        decoder: JSONDecoder?,
        context: NSManagedObjectContext?,
        fetchLimiter: FetchLimiter?
    ) {
        self.remoteConfig = remoteConfig
        self.remoteConfigComplection = remoteConfigComplection
        self.decoder = decoder
        self.context = context
        self.fetchLimiter = fetchLimiter
    }
    
    func fetchAndActivate<T>() -> Observable<Event<T>> {
        if fetchLimiter.fetchInProcess {
            return Observable.empty()
        }
        fetchLimiter.fetchInProcess = true
        remoteConfig.fetchAndActivate(completionHandler: remoteConfigComplection.completionHandler(status:error:))
        
        return remoteConfigComplection.result().flatMap { [weak self] status, error -> Observable<Event<T>> in
            var result = Observable<Event<T>>.empty()
            
            switch status {
            case .error:
                let error = error ?? AppError.unknown
                print("Remote config fetch error: \(error.localizedDescription)")
                result = Observable.just(Event.error(error))
            case .successFetchedFromRemote:
                print("Remote config fetched data from remote")
                try self?.updateDB()
            case .successUsingPreFetchedData:
                print("Remote config using prefetched data")
            @unknown default:
                print("Remote config unknown status")
            }
            self?.fetchLimiter.fetchInProcess = false
            return result
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
    private let _result = PublishRelay<(status: RemoteConfigFetchAndActivateStatus, error: Error?)>()
    
    func completionHandler(status: RemoteConfigFetchAndActivateStatus, error: Error?) -> Void {
        _result.accept((status, error))
    }
    
    func result() -> Observable<(status: RemoteConfigFetchAndActivateStatus, error: Error?)> {
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
