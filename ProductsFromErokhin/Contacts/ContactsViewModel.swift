//
//  ContactsViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 13.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

protocol ContactsViewModel {
    func contacts() -> Observable<Event<[SellerContacts]>>
}

class ContactsViewModelImpl: ContactsViewModel {
    
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    func contacts() -> Observable<Event<[SellerContacts]>> {
        repository.sellerContacts()
    }
}
