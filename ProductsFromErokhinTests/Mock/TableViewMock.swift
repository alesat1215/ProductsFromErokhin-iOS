//
//  TableViewMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 26.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class TableViewMock: UITableView {
    
    init() {
        super.init(frame: .init(), style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isReload = false
    override func reloadData() {
        isReload.toggle()
    }
}
