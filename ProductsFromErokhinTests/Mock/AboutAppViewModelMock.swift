//
//  AboutAppViewModelMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 15.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ProductsFromErokhin

class AboutAppViewModelMock: AboutAppViewModel {
    
    let aboutAppResult = PublishRelay<Event<[AboutApp]>>()
    var isAboutApp = false
    func aboutApp() -> Observable<Event<[AboutApp]>> {
        isAboutApp.toggle()
        return aboutAppResult.asObservable()
    }
    
    let nameResult = "name"
    func name() -> String {
        nameResult
    }
    
    let versionResult = "result"
    func version() -> String {
        versionResult
    }
    
    var linkResult: String?
    var isOpen = false
    func open(link: String?) {
        linkResult = link
        isOpen.toggle()
    }
}
