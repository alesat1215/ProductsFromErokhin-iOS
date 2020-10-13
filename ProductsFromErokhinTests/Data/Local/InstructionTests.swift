//
//  InstructionTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
import CoreData
@testable import ProductsFromErokhin

class InstructionTests: XCTestCase {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func tearDownWithError() throws {
        try Instruction.clearEntity(context: context)
    }
    
    func testUpdate() {
        let instructionRemote = InstructionRemote(title: "title", text: "text", img_path: "img_path")
        let order = 1
        
        let instruction = Instruction(context: context)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        
        instruction.update(from: instructionRemote, order: order)
        XCTAssertEqual(instruction.order, Int16(order))
        XCTAssertEqual(instruction.title, instructionRemote.title)
        XCTAssertEqual(instruction.text, instructionRemote.text)
        XCTAssertEqual(instruction.img_path, instructionRemote.img_path)
        
        waitForExpectations(timeout: 1)
    }

}
