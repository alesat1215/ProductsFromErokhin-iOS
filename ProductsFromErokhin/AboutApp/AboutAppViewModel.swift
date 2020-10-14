//
//  AboutAppViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

protocol AboutAppViewModel {
    func aboutApp() -> Observable<Event<[AboutApp]>>
}

class AboutAppViewModelImpl: AboutAppViewModel {
    private let repository: AppRepository! // di
    
    init(repository: AppRepository?) {
        self.repository = repository
    }
    
    func aboutApp() -> Observable<Event<[AboutApp]>> {
        repository.aboutApp()
    }
}
