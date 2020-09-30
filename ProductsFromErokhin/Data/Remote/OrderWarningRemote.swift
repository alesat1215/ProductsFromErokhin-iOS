//
//  OrderWarningRemote.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 30.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

struct OrderWarningRemote {
    let text: String
    let groups: [String]
}

extension OrderWarningRemote: Codable {
    enum CodingKeys: String, CodingKey {
        case text, groups
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = (try? values.decode(String.self, forKey: .text)) ?? ""
        groups = (try? values.decode([String].self, forKey: .groups)) ?? []
    }
}

extension OrderWarningRemote {
    func managedObject(context: NSManagedObjectContext) -> NSManagedObject {
        // Create entity & set values
        let orderWarning = NSEntityDescription.insertNewObject(forEntityName: "OrderWarning", into: context)
        (orderWarning as? OrderWarning)?.update(from: self)
        // Return result
        return orderWarning
    }
}
