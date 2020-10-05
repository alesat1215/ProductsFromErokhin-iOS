//
//  CartViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 04.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class CartViewModelMock: CartViewModel {
    
    init() {
        super.init(repository: nil, contactStore: nil)
    }
    
    var inCartCountResult: String?
    override func inCartCount() -> Observable<String?> {
        Observable.just(inCartCountResult)
    }
    
    var clearCartResult: Result<Void, Error> = .success(())
    var isClearCart = false
    override func clearCart() -> Result<Void, Error> {
        isClearCart.toggle()
        return clearCartResult
    }
    
    let productsResult = PublishRelay<Event<CoreDataSourceTableView<Product>>>()
    override func products() -> Observable<Event<CoreDataSourceTableView<Product>>> {
        productsResult.asObservable()
    }
    
    let totalInCartResult = PublishRelay<Int>()
    override func totalInCart() -> Observable<Int> {
        totalInCartResult.asObservable()
    }
    
    let warningResult = PublishRelay<Event<String>>()
    override func warning() -> Observable<Event<String>> {
        warningResult.asObservable()
    }
    
    let withoutWarningResult = PublishRelay<Bool>()
    override func withoutWarning() -> Observable<Bool> {
        withoutWarningResult.asObservable()
    }
    
    var isPhoneForOrder = false
    var phoneForOrderResult = Event<String>.error(AppError.unknown)
    override func phoneForOrder() -> Observable<Event<String>> {
        isPhoneForOrder.toggle()
        return Observable.just(phoneForOrderResult)
    }
    
    var isCheckContact = false
    override func checkContact(phone: String) -> Observable<Void> {
        isCheckContact.toggle()
        return Observable.just(())
    }
    
    var isMessage = false
    let messageResult = "Message"
    override func message() -> Observable<String> {
        isMessage.toggle()
        return Observable.just(messageResult)
    }
}
