//
//  OpenLink.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

protocol OpenLink {
    var app: UIApplicationMethods? { get }
    /** Create url for string & open it if can */
    func open(link: String?)
}

extension OpenLink {
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
