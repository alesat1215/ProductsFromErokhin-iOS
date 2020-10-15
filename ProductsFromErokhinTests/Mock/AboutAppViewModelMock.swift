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
    func aboutApp() -> Observable<Event<[AboutApp]>> {
        aboutAppResult.asObservable()
    }
    
    let nameResult = "name"
    func name() -> String {
        nameResult
    }
    
    let versionResult = "result"
    func version() -> String {
        versionResult
    }
    
    var phoneResult: String?
    var isCall = false
    func open(link: String?) {
        phoneResult = link
        isCall.toggle()
    }
}
