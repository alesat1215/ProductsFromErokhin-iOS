//
//  InstructionRemote.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 09.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

struct InstructionRemote {
    let title: String
    let text: String
    let img_path: String
}

extension InstructionRemote: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case title, text, img_path
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = (try? values.decode(String.self, forKey: .title)) ?? ""
        text = (try? values.decode(String.self, forKey: .text)) ?? ""
        img_path = (try? values.decode(String.self, forKey: .img_path)) ?? ""
    }
}

extension InstructionRemote {
    func managedObject(context: NSManagedObjectContext, order: Int) -> NSManagedObject {
        // Create entity & set values
        let sellerContacts = NSEntityDescription.insertNewObject(forEntityName: "Instruction", into: context)
        (sellerContacts as? Instruction)?.update(from: self, order: order)
        // Return result
        return sellerContacts
    }
}
