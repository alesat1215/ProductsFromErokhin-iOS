//
//  MockCell.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
@testable import ProductsFromErokhin

class CollectionViewCellMock: BindableCollectionViewCell<Product> {
    var isBind = false
    override func bind(model: Product?) {
        isBind.toggle()
    }
}
