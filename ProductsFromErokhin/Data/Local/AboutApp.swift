//
//  AboutApp.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

extension AboutApp: Ordered {
    /** Set values from AboutAppRemote with order */
    func update(from remote: AboutAppRemote, order: Int) {
        self.order = Int16(order)
        privacy = remote.privacy
        version = remote.version
        appStore = remote.appStore
    }
}
