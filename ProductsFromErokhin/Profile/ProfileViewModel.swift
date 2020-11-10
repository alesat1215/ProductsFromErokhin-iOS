//
//  ProfileViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileViewModel {
    func profile() -> Observable<Profile>
    func updateProfile(name: String?, phone: String?, address: String?) -> Result<Void, Error>
    func updateProfile2(name: String?, phone: String?, address: String?) -> Observable<Event<Void>>
}

class ProfileViewModelImpl: ProfileViewModel {
    
    private let repository: Repository! // di
    
    init(repository: Repository?) {
        self.repository = repository
    }
    
    func profile() -> Observable<Profile> {
        repository.profile().compactMap { $0.first }
    }
    
    func updateProfile(name: String?, phone: String?, address: String?) -> Result<Void, Error> {
        repository.updateProfile(name: name, phone: phone, address: address)
    }
    
    func updateProfile2(name: String?, phone: String?, address: String?) -> Observable<Event<Void>> {
        repository.updateProfile2(name: name, phone: phone, address: address)
    }
}
