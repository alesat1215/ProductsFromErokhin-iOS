//
//  PagesDataSourceMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
@testable import ProductsFromErokhin

class PagesDataSourceMock<T: AnyObject>: PagesDataSource<T> {
    init() {
        super.init(data: [], storyboardId: "")
    }
    var isLastPageResult = false
    override func isLastPage(_ page: UIViewController) -> Bool {
        isLastPageResult
    }
}
