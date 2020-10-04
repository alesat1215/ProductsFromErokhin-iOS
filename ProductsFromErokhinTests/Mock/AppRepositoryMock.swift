//
//  AppRepositoryMock.swift
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

class AppRepositoryMock: AppRepository {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        super.init(updater: nil, context: nil)
    }
    
    // MARK: - groups
    let groupsResult = CoreDataSourceCollectionViewMock(fetchRequest: Group.fetchRequestWithSort())
    var cellIdGroups: String?
    override func groups(cellId: String) -> Observable<Event<CoreDataSourceCollectionView<Group>>> {
        self.cellIdGroups = cellId
        return Observable.just(Event.next(groupsResult))
    }
    
    // MARK: - titles
    lazy var titlesResult = [Titles(context: context)]
    override func titles() -> Observable<Event<[Titles]>> {
        Observable.just(Event.next(titlesResult))
    }
    
    // MARK: - products
    let productsResultCollectionView = CoreDataSourceCollectionViewMock(fetchRequest: Product.fetchRequestWithSort())
    var predicateProductsCollectionView: NSPredicate?
    var cellIdProductsCollectionView: String?
    override func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSourceCollectionView<Product>>> {
        self.predicateProductsCollectionView = predicate
        self.cellIdProductsCollectionView = cellId
        return Observable.just(Event.next(productsResultCollectionView))
    }
    
    let productsResultTableView = CoreDataSourceTableViewMock(fetchRequest: Product.fetchRequestWithSort())
    var predicateProductsTableView: NSPredicate?
    var cellIdProductsTableView: String?
    override func products(predicate: NSPredicate? = nil, cellId: String) -> Observable<Event<CoreDataSourceTableView<Product>>> {
        self.predicateProductsTableView = predicate
        self.cellIdProductsTableView = cellId
        return Observable.just(Event.next(productsResultTableView))
    }
    
    var productResult = [Product]()
    var predicateProducts: NSPredicate?
    override func products(predicate: NSPredicate? = nil) -> Observable<[Product]> {
        self.predicateProducts = predicate
        return Observable.just(productResult)
    }
    
    var isClearCart = false
    override func clearCart() -> Result<Void, Error> {
        isClearCart.toggle()
        return .success(())
    }
    
    var orderWarningResult = [OrderWarning]()
    override func orderWarning() -> Observable<Event<[OrderWarning]>> {
        Observable.just(Event.next(orderWarningResult))
    }
}
