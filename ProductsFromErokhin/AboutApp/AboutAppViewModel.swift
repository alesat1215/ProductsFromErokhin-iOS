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
    func name() -> String
    func version() -> String
    func open(link: String?)
}

class AboutAppViewModelImpl: AboutAppViewModel {
    private let repository: AppRepository! // di
    private let app: UIApplicationMethods! // di
    
    init(repository: AppRepository?, app: UIApplicationMethods?) {
        self.repository = repository
        self.app = app
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
    
    func open(link: String?) {
        if let link = link, !link.isEmpty,
           let url = URL(string: link),
           app.canOpenURL(url)
        {
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}
