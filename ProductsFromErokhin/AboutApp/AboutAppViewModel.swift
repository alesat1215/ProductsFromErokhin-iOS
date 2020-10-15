//
//  AboutAppViewModel.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift

protocol AboutAppViewModel: OpenLink {
    func aboutApp() -> Observable<Event<[AboutApp]>>
    func name() -> String
    func version() -> String
    func open(link: String?)
}

class AboutAppViewModelImpl: AboutAppViewModel {
    
    private let repository: AppRepository! // di
//    var app: UIApplicationMethods? // di
    
    init(repository: AppRepository?, app: UIApplicationMethods?) {
        self.repository = repository
//        self.app = app
    }
    
    func aboutApp() -> Observable<Event<[AboutApp]>> {
        repository.aboutApp()
    }
    
    func name() -> String {
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    func version() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        return "\(version) (\(build))"
    }
    
}
