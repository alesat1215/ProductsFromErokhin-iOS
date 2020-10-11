//
//  TutorialViewModelMockTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import RxSwift
@testable import ProductsFromErokhin

class TutorialViewModelMockTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var viewModel: TutorialViewModelMock!
    private var instruction: Instruction!
    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        viewModel = TutorialViewModelMock()
        instruction = Instruction(context: context)
        instruction.title = "title"
        instruction.img_path = "img_path"
        instruction.text = "text"
    }

    override func tearDownWithError() throws {
        try Instruction.clearEntity(context: context)
    }
    
    func testInstructions() {
        var result: [Instruction]?
        viewModel.instructions().dematerialize()
            .subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
        XCTAssertNil(result)
        viewModel.instructionsResult.accept(Event.next([instruction]))
        XCTAssertEqual(result, [instruction])
    }
    
    func testReadTutorial() {
        XCTAssertFalse(viewModel.isReadTutorial)
        viewModel.readTutorial()
        XCTAssertTrue(viewModel.isReadTutorial)
    }

}
