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
    func call(to phone: String?)
}

class ContactsViewModelImpl: ContactsViewModel {
    
    private let repository: AppRepository! // di
    private let app: UIApplicationMethods!
    
    init(repository: AppRepository?, app: UIApplicationMethods?) {
        self.repository = repository
        self.app = app
    }
    
    func contacts() -> Observable<Event<[SellerContacts]>> {
        repository.sellerContacts()
    }
    
    func call(to phone: String?) {
        if let phone = phone, !phone.isEmpty,
           let url = URL(string: "telprompt://\(phone)"),
           app.canOpenURL(url)
        {
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}
