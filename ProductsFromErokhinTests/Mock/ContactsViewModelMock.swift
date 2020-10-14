//
//  ContactsViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class ContactsViewModelMock: ContactsViewModel {
    let contactsResult = PublishRelay<Event<[SellerContacts]>>()
    func contacts() -> Observable<Event<[SellerContacts]>> {
        contactsResult.asObservable()
    }
    
    var phoneResult: String?
    var isCall = false
    func call(to phone: String?) {
        phoneResult = phone
        isCall.toggle()
    }
    
    
}
