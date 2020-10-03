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
    // func flatMapError(_ handler: ((_ error: Error) -> ())? = nil) -> Observable<Element.Element>
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
    
    // func flatMapError<T>(_ handler: ((_ error: Error) -> Observable<T>)? = nil) -> Observable<Element.Element>
    func testFlatMapErrorObservableHandler() {
        // Success
        let test = "test"
        var testObservable = Observable.just(Event.next(test))
        XCTAssertEqual(test, try testObservable.flatMapError().toBlocking().first())
        // Error
        let disposeBag = DisposeBag()
        testObservable = Observable.just(Event.error(AppError.unknown))
        var error: Error?
        let handlerObservable = PublishSubject<Error>()
        func testHandlerObservable(error: Error) -> Observable<Error> {
            handlerObservable.onNext(error)
            handlerObservable.onCompleted()
            return handlerObservable.asObservable()
        }
        handlerObservable.subscribe(onNext: {
            error = $0
        }).disposed(by: disposeBag)
        var result = testObservable.flatMapError { testHandlerObservable(error: $0) }.toBlocking().materialize()
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
