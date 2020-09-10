//
//  Titles.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 10.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

extension Titles: Ordered {
    func update(from remote: TitlesRemote, order: Int = 0) {
        self.order = Int16(order)
        title = remote.title
        img = remote.img
        imgTitle = remote.imgTitle
        productsTitle = remote.productsTitle
        productsTitle2 = remote.productsTitle2
    }
}
