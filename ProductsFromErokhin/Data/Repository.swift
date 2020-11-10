//
//  ProductsRepository.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 03.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData

protocol Repository {
    /** Update database from remote if needed */
    func loadData() -> Observable<Event<Void>>
    /**
     Get groups from database & update it if needed
     - returns: Observable array with groups
     */
    func groups(cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<Group>>>
    /**
    Get titles from database & update it if needed
    - returns: Observable array with products
    */
    func titles() -> Observable<Event<[Titles]>>
    /**
    Get products from database & update it if needed
    - returns: Observable dataSource with products for collection view
    */
    func products(predicate: NSPredicate?, cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<Product>>>
    /**
    Get products from database & update it if needed
    - returns: Observable dataSource with products for table view
    */
    func products(predicate: NSPredicate?, cellId: String) -> Observable<Event<CoreDataSourceTableView<Product>>>
    /**
    Get products from database
    - returns: Observable array with products
    */
    func products(predicate: NSPredicate?) -> Observable<[Product]>
    /**
    Get orderWarning from database & update it if needed
    - returns: Observable array with orderWarning
    */
    func orderWarning() -> Observable<Event<[OrderWarning]>>
    /** Clear ProductInCart entity & save context */
    func clearCart() -> Result<Void, Error>
    
    func clearCart2() -> Observable<Event<Void>>
    /**
    Get sellerContacts from database & update it if needed
    - returns: Observable array with sellerContacts
    */
    func sellerContacts() -> Observable<Event<[SellerContacts]>>
    /**
     Get Profile from database
     - returns: Observable array with Profile
     */
    func profile() -> Observable<[Profile]>
    /** Clear profile entity, add new with params, save & return result */
    func updateProfile(name: String?, phone: String?, address: String?) -> Result<Void, Error>
    
    func updateProfile2(name: String?, phone: String?, address: String?) -> Observable<Event<Void>>
    /**
    Get instructions from database & update it if needed
    - returns: Observable array with instructions
    */
    func instructions() -> Observable<Event<[Instruction]>>
    /**
    Get aboutProducts from database & update it if needed
    - returns: Observable dataSource with aboutProducts for collection view
    */
    func aboutProducts(cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<AboutProducts>>>
    /**
    Get aboutApp from database & update it if needed
    - returns: Observable array with aboutApp
    */
    func aboutApp() -> Observable<Event<[AboutApp]>>
}

/** Repository for groups & products */
class RepositoryImpl: Repository {
    private let updater: DatabaseUpdater! // di
//    private let context: NSManagedObjectContext!// di
    private let container: NSPersistentContainer! // di
    
    init(updater: DatabaseUpdater?, container: NSPersistentContainer?) {
        self.updater = updater
//        self.context = context
        self.container = container
    }
    /** Update database from remote if needed */
    func loadData() -> Observable<Event<Void>> {
        updater.sync()
    }
    /**
     Get groups from database & update it if needed
     - returns: Observable array with groups
     */
    func groups(cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<Group>>> {
        Observable.merge([
            container.viewContext.rx.coreDataSource(
                cellId: cellId,
                fetchRequest: Group.fetchRequestWithSort()
            ).materialize(),
            updater.sync()
        ])
    }
    /**
    Get titles from database & update it if needed
    - returns: Observable array with products
    */
    func titles() -> Observable<Event<[Titles]>> {
        Observable.merge([
            container.viewContext.rx.entities(fetchRequest: Titles.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    /**
    Get products from database & update it if needed
    - returns: Observable dataSource with products for collection view
    */
    func products(predicate: NSPredicate? = nil, cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        Observable.merge([
            container.viewContext.rx.coreDataSource(
                cellId: cellId,
                fetchRequest: Product.fetchRequestWithSort(predicate: predicate)
            ).materialize(),
            updater.sync()
        ])
    }
    /**
    Get products from database & update it if needed
    - returns: Observable dataSource with products for table view
    */
    func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSourceTableView<Product>>> {
        Observable.merge([
            container.viewContext.rx.coreDataSource(
                cellId: cellId,
                fetchRequest: Product.fetchRequestWithSort(predicate: predicate)
            ).materialize(),
            updater.sync()
        ])
    }
    /**
    Get products from database
    - returns: Observable array with products
    */
    func products(predicate: NSPredicate? = nil) -> Observable<[Product]> {
        container.viewContext.rx.entities(fetchRequest: Product.fetchRequestWithSort(predicate: predicate))
    }
    /**
    Get orderWarning from database & update it if needed
    - returns: Observable array with orderWarning
    */
    func orderWarning() -> Observable<Event<[OrderWarning]>> {
        Observable.merge([
            container.viewContext.rx.entities(fetchRequest: OrderWarning.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    /** Clear ProductInCart entity & save context */
    func clearCart() -> Result<Void, Error> {
        do {
            try ProductInCart.clearEntity(context: container.viewContext)
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func clearCart2() -> Observable<Event<Void>> {
        Observable.create { [weak self] observer in
            self?.container.performBackgroundTask { context in
                do {
                    try ProductInCart.clearEntity(context: context)
                    if context.hasChanges {
                        try context.save()
                    }
                    DispatchQueue.main.async {
                        observer.onNext(Event.next(()))
                        observer.onCompleted()
                    }
                } catch {
                    DispatchQueue.main.async {
                        context.undo()
                        observer.onNext(Event.error(error))
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    /**
    Get sellerContacts from database & update it if needed
    - returns: Observable array with sellerContacts
    */
    func sellerContacts() -> Observable<Event<[SellerContacts]>> {
        Observable.merge([
            container.viewContext.rx.entities(fetchRequest: SellerContacts.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    /**
     Get Profile from database
     - returns: Observable array with Profile
     */
    func profile() -> Observable<[Profile]> {
        container.viewContext.rx.entities(fetchRequest: Profile.fetchRequestWithSort())
    }
    /** Clear profile entity, add new with params, save & return result */
    func updateProfile(name: String?, phone: String?, address: String?) -> Result<Void, Error> {
        do {
            try Profile.clearEntity(context: container.viewContext)
            let profile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: container.viewContext)
            (profile as? Profile)?.order = 0
            (profile as? Profile)?.name = name
            (profile as? Profile)?.phone = phone
            (profile as? Profile)?.address = address
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func updateProfile2(name: String?, phone: String?, address: String?) -> Observable<Event<Void>> {
        Observable.create { [weak self] observer in
            self?.container.performBackgroundTask { context in
                do {
                    try Profile.clearEntity(context: context)
                    let profile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context)
                    (profile as? Profile)?.order = 0
                    (profile as? Profile)?.name = name
                    (profile as? Profile)?.phone = phone
                    (profile as? Profile)?.address = address
                    if context.hasChanges {
                        try context.save()
                    }
                    DispatchQueue.main.async {
                        observer.onNext(Event.next(()))
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
    /**
    Get instructions from database & update it if needed
    - returns: Observable array with instructions
    */
    func instructions() -> Observable<Event<[Instruction]>> {
        Observable.merge([
            container.viewContext.rx.entities(fetchRequest: Instruction.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    /**
    Get aboutProducts from database & update it if needed
    - returns: Observable dataSource with aboutProducts for collection view
    */
    func aboutProducts(cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<AboutProducts>>> {
        Observable.merge([
            container.viewContext.rx.coreDataSource(
                cellId: cellId,
                fetchRequest: AboutProducts.fetchRequestWithSort(sortDescriptors: [
                    NSSortDescriptor(key: "section", ascending: true),
                    NSSortDescriptor(key: "order", ascending: true)
                ]),
                sectionNameKeyPath: "section"
            ).materialize(),
            updater.sync()
        ])
    }
    /**
    Get aboutApp from database & update it if needed
    - returns: Observable array with aboutApp
    */
    func aboutApp() -> Observable<Event<[AboutApp]>> {
        Observable.merge([
            container.viewContext.rx.entities(fetchRequest: AboutApp.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
}
