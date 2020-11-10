//
//  ProfileViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class ProfileViewModelMock: ProfileViewModel {
    
    let profileResult = PublishRelay<Profile>()
    func profile() -> Observable<Profile> {
        profileResult.asObservable()
    }
    
    var updateProfileResult = PublishRelay<Event<Void>>()
    var isUpdateProfile = false
    var updateProfileParamsResult: (name: String?, phone: String?, address: String?)?
    func updateProfile(name: String?, phone: String?, address: String?) -> Observable<Event<Void>> {
        updateProfileParamsResult = (name, phone, address)
        isUpdateProfile.toggle()
        return updateProfileResult.asObservable()
    }
    
    
}
