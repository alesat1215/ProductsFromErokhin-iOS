//
//  TableViewMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 28.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class TableViewMockTests: XCTestCase {

    func testTableViewMock() {
        let tableView = TableViewMock()
        // Cell
        XCTAssertEqual(tableView.dequeueReusableCell(withIdentifier: "", for: .init()), tableView.cell)
        // Reload
        XCTAssertFalse(tableView.isReload)
        tableView.reloadData()
        XCTAssertTrue(tableView.isReload)
        // Insert
        XCTAssertFalse(tableView.isInsert)
        tableView.insertRows(at: [], with: .automatic)
        XCTAssertTrue(tableView.isInsert)
        // Delete
        XCTAssertFalse(tableView.isDelete)
        tableView.deleteRows(at: [], with: .automatic)
        XCTAssertTrue(tableView.isDelete)
        // Items
        XCTAssertEqual(tableView.cellForRow(at: IndexPath()), tableView.cell)
        // Scroll
        XCTAssertFalse(tableView.isScroll)
        tableView.scrollToRow(at: IndexPath(), at: .bottom, animated: true)
        XCTAssertTrue(tableView.isScroll)
        // Visible cells
        XCTAssertEqual(tableView.indexPathsForVisibleRows, tableView.indexPathsForVisibleRowsResult)
    }

}
