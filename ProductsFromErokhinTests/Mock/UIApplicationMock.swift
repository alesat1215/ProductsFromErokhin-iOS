//
//  UIApplicationMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
@testable import ProductsFromErokhin

class UIApplicationMock: UIApplicationMethods {
    var canOpenURLParamResult: URL?
    var canOpenURLResult = true
    var isCanOpenURL = false
    func canOpenURL(_ url: URL) -> Bool {
        canOpenURLParamResult = url
        isCanOpenURL.toggle()
        return canOpenURLResult
    }
    
    var openResult: URL?
    var isOpen = false
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        openResult = url
        isOpen.toggle()
    }
}
