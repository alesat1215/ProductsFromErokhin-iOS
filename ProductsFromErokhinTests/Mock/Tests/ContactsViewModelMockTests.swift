//
//  ContactsViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class ContactsViewModelMockTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    private var viewModel: ContactsViewModelMock!

    override func setUpWithError() throws {
        viewModel = ContactsViewModelMock()
    }
    
    func testContacts() {
        var result: [SellerContacts]?
        viewModel.contacts().dematerialize()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertNil(result)
        viewModel.contactsResult.accept(Event.next([]))
        XCTAssertNotNil(result)
    }
    
    func testOpen() {
        XCTAssertNil(viewModel.phoneResult)
        XCTAssertFalse(viewModel.isCall)
        viewModel.open(link: "test")
        XCTAssertEqual(viewModel.phoneResult, "test")
        XCTAssertTrue(viewModel.isCall)
    }

}
