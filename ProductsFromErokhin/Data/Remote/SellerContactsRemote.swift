//
//  SellerContactsRemote.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 02.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

struct SellerContactsRemote {
    let phone: String
    let address: String
}

extension SellerContactsRemote: Codable {
    enum CodingKeys: String, CodingKey {
        case phone, address
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        phone = (try? values.decode(String.self, forKey: .phone)) ?? ""
        address = (try? values.decode(String.self, forKey: .address)) ?? ""
    }
}

extension SellerContactsRemote {
    func managedObject(context: NSManagedObjectContext) -> NSManagedObject {
        // Create entity & set values
        let sellerContacts = NSEntityDescription.insertNewObject(forEntityName: "SellerContacts", into: context)
        (sellerContacts as? SellerContacts)?.update(from: self)
        // Return result
        return sellerContacts
    }
}
