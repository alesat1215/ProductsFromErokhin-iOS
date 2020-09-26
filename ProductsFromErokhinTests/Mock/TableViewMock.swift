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
    
    let cell = TableViewCellMock()
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return cell
    }
    
    var isReload = false
    override func reloadData() {
        isReload.toggle()
    }
    
    var isInsert = false
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        isInsert.toggle()
    }
    
    var isDelete = false
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        isDelete.toggle()
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        cell
    }
}
