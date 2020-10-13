//
//  AboutProducts.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 12.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

extension AboutProducts: Ordered {    
    /** Set values from InstructionRemote with order */
    func update(from remote: AboutProductsRemote, order: Int) {
        self.order = Int16(order)
        title = remote.title
        text = remote.text
        img = remote.img
        section = remote.img.isEmpty ? 0 : 1
    }
}
