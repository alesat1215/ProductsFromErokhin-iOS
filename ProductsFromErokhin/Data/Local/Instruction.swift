//
//  Instruction.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 09.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

extension Instruction: Ordered {
    /** Set values from InstructionRemote with order */
    func update(from remote: InstructionRemote, order: Int) {
        self.order = Int16(order)
        title = remote.title
        text = remote.text
        img_path = remote.img_path
    }
}
