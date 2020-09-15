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

/** Sync database with remote config */
class DatabaseUpdater {
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
    
    /** Sync database with remote data */
    func sync<T>() -> Observable<Event<T>> {
        // Check can fetch
        if fetchLimiter.fetchInProcess {
            return Observable.empty()
        }
        // Block fetch for other requests
        fetchLimiter.fetchInProcess = true
        // Fetch & activate remote config
        remoteConfig.fetchAndActivate(completionHandler: remoteConfigComplection.completionHandler(status:error:))
        // Get result for request
        return remoteConfigComplection.result().flatMap { [weak self] status, error -> Observable<Event<T>> in
            // Default result
            var result = Observable<Event<T>>.empty()
            // Update database only when config wethed from remote
            switch status {
            case .error:
                let error = error ?? AppError.unknown
                print("Remote config fetch error: \(error.localizedDescription)")
                // Set error to result
                result = Observable.just(Event.error(error))
            case .successFetchedFromRemote:
                print("Remote config fetched data from remote")
                // Update database from remote config
                try self?.update()
            case .successUsingPreFetchedData:
                print("Remote config using prefetched data")
            @unknown default:
                print("Remote config unknown status")
            }
            // Unblock fetch for other requests
            self?.fetchLimiter.fetchInProcess = false
            return result
        }
    }
    /** Update database from remote data */
    private func update() throws {
        try updateProducts()
        try updateTitles()
        // Save result
        if context.hasChanges {
            try context.save()
        }
    }
    
    func updateProducts() throws {
        // Get groups with products from remote data
        let groups: [GroupRemote] = try remoteData(key: .products)
        // Delete all groups with products from database
        try Group.clearEntity(context: context)
        // Create groups & products entitys with order from remote
        var productOrder = 0
        let allInCart = try context.fetch(ProductInCart.fetchRequestWithSortByName())
        groups.enumerated().forEach {
            context.insert($1.managedObject(context: context, groupOrder: $0, productOrder: &productOrder, allInCart: allInCart))
        }
    }
    
    func updateTitles() throws {
        // Get titles from remote data
        let titles: TitlesRemote = try remoteData(key: .titles)
        // Delete all titles from database
        try Titles.clearEntity(context: context)
        // Create titles entity from remote
        context.insert(titles.managedObject(context: context))
    }
    
    /** Get data from remote config & decode it from JSON */
    private func remoteData<T: Codable>(key: RemoteDataKeys) throws -> T {
        try decoder.decode(T.self, from: remoteConfig![key.rawValue].dataValue)
    }
    
}

// MARK: - Keys
/** Keys for remote config parameters */
fileprivate enum RemoteDataKeys: String {
    case products, titles
}

/** Completion handler for fetchAndActivate with observable result */
class RemoteConfigComplection {
    private let _result = PublishRelay<(status: RemoteConfigFetchAndActivateStatus, error: Error?)>()
    
    func completionHandler(status: RemoteConfigFetchAndActivateStatus, error: Error?) -> Void {
        _result.accept((status, error))
    }
    /** - returns: Observable result of fetchAndActivate method */
    func result() -> Observable<(status: RemoteConfigFetchAndActivateStatus, error: Error?)> {
        _result.asObservable()
    }
}

/** Limit for run fetchAndActivate method */
class FetchLimiter {
    /** Fetch status */
    private var _fetchInProcess = false
    /** Serial queue for get or set value thread-safety */
    private let serialQueue: DispatchQueue?
    
    init(serialQueue: DispatchQueue?) {
        self.serialQueue = serialQueue
    }
    /** Thread-safety fetch status value */
    var fetchInProcess: Bool {
        get {
            return serialQueue?.sync { _fetchInProcess } ?? false
        }
        set {
            serialQueue?.sync { _fetchInProcess = newValue }
        }
    }
}
