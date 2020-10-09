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

/** Repository for groups & products */
class AppRepository {
    private let updater: DatabaseUpdater! // di
    private let context: NSManagedObjectContext!// di
    
    init(updater: DatabaseUpdater?, context: NSManagedObjectContext?) {
        self.updater = updater
        self.context = context
    }
    /**
     Get groups from database & update it if needed
     - returns: Observable array with groups
     */
    func groups(cellId: String) -> Observable<Event<CoreDataSourceCollectionView<Group>>> {
        Observable.merge([
            context.rx.coreDataSource(
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
            context.rx.entities(fetchRequest: Titles.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    /**
    Get products from database & update it if needed
    - returns: Observable dataSource with products for collection view
    */
    func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        Observable.merge([
            context.rx.coreDataSource(
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
            context.rx.coreDataSource(
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
        context.rx.entities(fetchRequest: Product.fetchRequestWithSort(predicate: predicate))
    }
    /**
    Get orderWarning from database & update it if needed
    - returns: Observable array with orderWarning
    */
    func orderWarning() -> Observable<Event<[OrderWarning]>> {
        Observable.merge([
            context.rx.entities(fetchRequest: OrderWarning.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    /** Clear ProductInCart entity & save context */
    func clearCart() -> Result<Void, Error> {
        do {
            try ProductInCart.clearEntity(context: context)
            if context.hasChanges {
                try context.save()
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    /**
    Get sellerContacts from database & update it if needed
    - returns: Observable array with sellerContacts
    */
    func sellerContacts() -> Observable<Event<[SellerContacts]>> {
        Observable.merge([
            context.rx.entities(fetchRequest: SellerContacts.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    /**
     Get Profile from database
     - returns: Observable array with Profile
     */
    func profile() -> Observable<[Profile]> {
        context.rx.entities(fetchRequest: Profile.fetchRequestWithSort())
    }
    /** Clear profile entity, add new with params, save & return result */
    func updateProfile(name: String?, phone: String?, address: String?) -> Result<Void, Error> {
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
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    /**
    Get instructions from database & update it if needed
    - returns: Observable array with instructions
    */
    func instructions() -> Observable<Event<[Instruction]>> {
        Observable.merge([
            context.rx.entities(fetchRequest: Instruction.fetchRequestWithSort()).materialize(),
            updater.sync()
        ])
    }
    
}
