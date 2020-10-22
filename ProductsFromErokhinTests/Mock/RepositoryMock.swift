//
//  RepositoryMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 19.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class RepositoryMock: Repository {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - load
    var loadDataResult: Event<Void>?
    func loadData() -> Observable<Event<Void>> {
        loadDataResult == nil ? Observable.empty() : Observable.just(loadDataResult!)
    }
    
    // MARK: - groups
    let groupsResult = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
    var cellIdGroups: [String]?
    func groups(cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<Group>>> {
        self.cellIdGroups = cellId
        return Observable.just(Event.next(groupsResult))
    }
    
    // MARK: - titles
    lazy var titlesResult = [Titles(context: context)]
    func titles() -> Observable<Event<[Titles]>> {
        Observable.just(Event.next(titlesResult))
    }
    
    // MARK: - products
    let productsResultCollectionView = CoreDataSourceCollectionViewMock(fetchRequest: Product.fetchRequestWithSort())
    var predicateProductsCollectionView: NSPredicate?
    var cellIdProductsCollectionView: [String]?
    func products(predicate: NSPredicate? = nil, cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        self.predicateProductsCollectionView = predicate
        self.cellIdProductsCollectionView = cellId
        return Observable.just(Event.next(productsResultCollectionView))
    }
    
    let productsResultTableView = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
    var predicateProductsTableView: NSPredicate?
    var cellIdProductsTableView: String?
    func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSourceTableView<Product>>> {
        self.predicateProductsTableView = predicate
        self.cellIdProductsTableView = cellId
        return Observable.just(Event.next(productsResultTableView))
    }
    
    var productResult = [Product]()
    var predicateProducts: NSPredicate?
    func products(predicate: NSPredicate? = nil) -> Observable<[Product]> {
        self.predicateProducts = predicate
        return Observable.just(productResult)
    }
    
    // MARK: - cart
    var isClearCart = false
    func clearCart() -> Result<Void, Error> {
        isClearCart.toggle()
        return .success(())
    }
    
    var orderWarningResult = [OrderWarning]()
    func orderWarning() -> Observable<Event<[OrderWarning]>> {
        Observable.just(Event.next(orderWarningResult))
    }
    
    var sellerContactsResult = [SellerContacts]()
    func sellerContacts() -> Observable<Event<[SellerContacts]>> {
        Observable.just(Event.next(sellerContactsResult))
    }
    
    // MARK: - profile
    var profileResult = [Profile]()
    func profile() -> Observable<[Profile]> {
        Observable.just(profileResult)
    }
    
    var updateProfileResult: Result<Void, Error> = .success(())
    func updateProfile(name: String?, phone: String?, address: String?) -> Result<Void, Error> {
        updateProfileResult
    }
    
    // MARK: - instructions
    var instructionsResult = [Instruction]()
    func instructions() -> Observable<Event<[Instruction]>> {
        Observable.just(Event.next(instructionsResult))
    }
    
    //MARK: - about products
    var aboutProductsResult = CoreDataSourceCollectionViewMock(fetchRequest: AboutProducts.fetchRequestWithSort())
    var aboutProductsCellIdResult = [String]()
    func aboutProducts(cellId: [String]) -> Observable<Event<CoreDataSourceCollectionView<AboutProducts>>> {
        aboutProductsCellIdResult = cellId
        return Observable.just(Event.next(aboutProductsResult))
    }
    
    //MARK: - about app
    var aboutAppResult = [AboutApp]()
    func aboutApp() -> Observable<Event<[AboutApp]>> {
        Observable.just(Event.next(aboutAppResult))
    }
}
