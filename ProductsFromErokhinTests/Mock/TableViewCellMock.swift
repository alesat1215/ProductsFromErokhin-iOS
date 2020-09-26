//
//  TableViewCellMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 26.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
@testable import ProductsFromErokhin

class TableViewCellMock: BindableTableViewCell<Product> {
    var isBind = false
    override func bind(model: Product?) {
        isBind.toggle()
    }
}
