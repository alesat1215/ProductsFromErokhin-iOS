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
}

class ProfileViewModelImpl: ProfileViewModel {
    
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    func profile() -> Observable<Profile> {
        repository.profile().compactMap { $0.first }
    }
}
