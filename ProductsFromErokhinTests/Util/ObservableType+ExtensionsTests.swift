//
//  ObservableType+ExtensionsTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 17.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking

@testable import ProductsFromErokhin

class ObservableType_ExtensionsTests: XCTestCase {

    func testFlatMapError() {
        // Success
        let test = "test"
        var testObservable = Observable.just(Event.next(test))
        XCTAssertEqual(test, try testObservable.flatMapError().toBlocking().first())
        // Error
        testObservable = Observable.just(Event.error(AppError.unknown))
        var error: Error?
        var result = testObservable.flatMapError { error = $0 }.toBlocking().materialize()
        switch result {
        case .completed(elements: let elements):
            XCTAssertTrue(elements.isEmpty)
        default:
            XCTFail("Must be completed")
        }
        XCTAssertEqual(error?.localizedDescription, AppError.unknown.localizedDescription)
        // Empty
        testObservable = Observable.empty()
        result = testObservable.flatMapError().toBlocking().materialize()
        switch result {
        case .completed(elements: let elements):
            XCTAssertTrue(elements.isEmpty)
        default:
            XCTFail("Must be completed")
        }
    }
    
}
