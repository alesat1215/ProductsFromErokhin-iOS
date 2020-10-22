//
//  NWPathMonitorMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 22.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest

class NWPathMonitorMockTests: XCTestCase {
    private var monitor: NWPathMonitorMock!

    override func setUpWithError() throws {
        monitor = NWPathMonitorMock()
    }
    
    func testStart() {
        XCTAssertFalse(monitor.isStart)
        monitor.start(queue: DispatchQueue(label: "Test"))
        XCTAssertTrue(monitor.isStart)
    }
    
    func testCancel() {
        XCTAssertFalse(monitor.isCancel)
        monitor.cancel()
        XCTAssertTrue(monitor.isCancel)
    }

}
