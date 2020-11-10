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

// MARK: - Database
protocol DatabaseUpdater {
    /** Sync database with remote data */
    func sync<T>() -> Observable<Event<T>>
}
/** Sync database with remote config */
class DatabaseUpdaterImpl<R: RemoteConfigMethods>: DatabaseUpdater {
    private let remoteConfig: R! // di
    private let decoder: JSONDecoder! // di
//    private let context: NSManagedObjectContext! // di
    private let container: NSPersistentContainer! // di
    private let fetchLimiter: FetchLimiter! // di
    
    init(
        remoteConfig: R?,
        decoder: JSONDecoder?,
//        context: NSManagedObjectContext?,
        container: NSPersistentContainer?,
        fetchLimiter: FetchLimiter?
    ) {
        self.remoteConfig = remoteConfig
        self.decoder = decoder
//        self.context = context
        self.container = container
        self.fetchLimiter = fetchLimiter
    }
    
    /** Sync database with remote data.
    - Returns: For success get data from remote return Observable.empty(). For error - Observable.just(Event.error(error))
     */
    func sync<T>() -> Observable<Event<T>> {
        // Check can fetch
        if fetchLimiter.fetchInProcess {
            return Observable.empty()
        }
        // Block fetch for other requests
        fetchLimiter.fetchInProcess = true
        // Fetch & activate remote config
        return remoteConfig.rx.fetchAndActivate().flatMap { [weak self] status, error -> Observable<Event<T>> in
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
                result = self?.update() ?? Observable.empty()
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
    private func update<T>() -> Observable<Event<T>> {
        Observable.create { [weak self] observer in
            self?.container.performBackgroundTask { [weak self] context in
                do {
                    try self?.updateProducts(context)
                    try self?.updateTitles(context)
                    try self?.updateOrderWarning(context)
                    try self?.updateSellerContacts(context)
                    try self?.updateInstructions(context)
                    try self?.updateAboutProducts(context)
                    try self?.updateAboutApp(context)
                    if context.hasChanges {
                        try context.save()
                    }
                    DispatchQueue.main.async {
                        observer.onCompleted()
                    }
                } catch {
                    context.undo()
                    DispatchQueue.main.async {
                        observer.onNext(Event.error(error))
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    private func updateProducts(_ context: NSManagedObjectContext) throws {
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
    
    private func updateTitles(_ context: NSManagedObjectContext) throws {
        // Get titles from remote data
        let titles: TitlesRemote = try remoteData(key: .titles)
        // Delete all titles from database
        try Titles.clearEntity(context: context)
        // Create titles entity from remote
        context.insert(titles.managedObject(context: context))
    }
    
    private func updateOrderWarning(_ context: NSManagedObjectContext) throws {
        // Get orderWarning from remote data
        let orderWarning: OrderWarningRemote = try remoteData(key: .orderWarning)
        // Delete all orderWarnings from database
        try OrderWarning.clearEntity(context: context)
        // Create orderWarning entity from remote
        context.insert(orderWarning.managedObject(context: context))
    }
    
    private func updateSellerContacts(_ context: NSManagedObjectContext) throws {
        // Get sellerContact from remote data
        let sellerContact: SellerContactsRemote = try remoteData(key: .contacts)
        // Delete all sellerContact from database
        try SellerContacts.clearEntity(context: context)
        // Create sellerContact entity from remote
        context.insert(sellerContact.managedObject(context: context))
    }
    
    private func updateInstructions(_ context: NSManagedObjectContext) throws {
        // Get instructions from remote data
        let instructions: [InstructionRemote] = try remoteData(key: .instructions)
        // Delete all instructions from database
        try Instruction.clearEntity(context: context)
        // Create instructions entity from remote
        instructions.enumerated().forEach {
            context.insert($1.managedObject(context: context, order: $0))
        }
    }
    
    private func updateAboutProducts(_ context: NSManagedObjectContext) throws {
        // Get aboutProducts from remote data
        let aboutProducts: [AboutProductsRemote] = try remoteData(key: .aboutProducts)
        // Delete all aboutProducts from database
        try AboutProducts.clearEntity(context: context)
        // Create aboutProducts entity from remote
        aboutProducts.enumerated().forEach {
            context.insert($1.managedObject(context: context, order: $0))
        }
    }
    
    private func updateAboutApp(_ context: NSManagedObjectContext) throws {
        // Get aboutApp from remote data
        let aboutApp: AboutAppRemote = try remoteData(key: .aboutApp)
        // Delete all aboutApp from database
        try AboutApp.clearEntity(context: context)
        // Create aboutApp entity from remote
        context.insert(aboutApp.managedObject(context: context))
    }
    
    /** Get data from remote config & decode it from JSON */
    private func remoteData<T: Codable>(key: RemoteDataKeys) throws -> T {
        try decoder.decode(T.self, from: remoteConfig[key.rawValue].dataValue)
    }
    
}

// MARK: - Remote config
/** Keys for remote config parameters */
fileprivate enum RemoteDataKeys: String {
    case products, titles, orderWarning = "order_warning", contacts, instructions, aboutProducts = "about_products_list", aboutApp = "about_app_ios"
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
