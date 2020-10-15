//
//  OpenLink.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

protocol OpenLink {
    var app: UIApplicationMethods? { get }
    /** Create url from string & open it if can */
    func open(link: String?)
}

extension OpenLink {
    var app: UIApplicationMethods? {
        UIApplication.shared
    }
    func open(link: String?) {
        if let link = link, !link.isEmpty,
           let url = URL(string: link),
           let app = app,
           app.canOpenURL(url)
        {
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}
