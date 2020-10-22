//
//  NWPathMonitor+RxTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 22.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class NWPathMonitor_RxTests: XCTestCase {
    
    func testStatus() {
        var disposeBag = DisposeBag()
        let monitor = NWPathMonitorMock()
        var result: Bool?
        // Start
        XCTAssertFalse(monitor.isStart)
        monitor.rx.status().subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertTrue(monitor.isStart)
        // Not satisfate
        XCTAssertNil(result)
        monitor.pathUpdateHandler?(NWPathMock(status: .unsatisfied))
        XCTAssertFalse(result!)
        result = nil
        monitor.pathUpdateHandler?(NWPathMock(status: .requiresConnection))
        XCTAssertFalse(result!)
        // Satisfate
        monitor.pathUpdateHandler?(NWPathMock(status: .satisfied))
        XCTAssertTrue(result!)
        // Dispose
        XCTAssertFalse(monitor.isCancel)
        disposeBag = DisposeBag()
        XCTAssertTrue(monitor.isCancel)
    }

}
