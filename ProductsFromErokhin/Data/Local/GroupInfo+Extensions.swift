//
//  GroupInfo+Extensions.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 05.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

extension GroupInfo: Ordered {
    func update(from remote: Group, order: Int) {
        self.order = Int16(order)
        name = remote.name
    }
    
//    typealias T = GroupInfo
}
