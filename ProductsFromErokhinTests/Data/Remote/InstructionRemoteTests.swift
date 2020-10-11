//
//  InstructionRemoteTests.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 11.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import XCTest
@testable import ProductsFromErokhin

class InstructionRemoteTests: XCTestCase {
    
    func testManagedObject() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let instructionRemote = InstructionRemote(title: "title", text: "text", img_path: "img_path")
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context).isInverted = true
        expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: context)
        
        let instruction = instructionRemote.managedObject(context: context, order: 1) as! Instruction
        XCTAssertEqual(instruction.order, 1)
        XCTAssertEqual(instruction.title, instructionRemote.title)
        XCTAssertEqual(instruction.text, instructionRemote.text)
        XCTAssertEqual(instruction.img_path, instructionRemote.img_path)
        
        waitForExpectations(timeout: 1)
    }

}
