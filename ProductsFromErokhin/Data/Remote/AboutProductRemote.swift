//
//  AboutProductRemote.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 12.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

struct AboutProductsRemote {
    let title: String
    let text: String
    let img: String
}

extension AboutProductsRemote: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case title, text, img
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = (try? values.decode(String.self, forKey: .title)) ?? ""
        text = (try? values.decode(String.self, forKey: .text)) ?? ""
        img = (try? values.decode(String.self, forKey: .img)) ?? ""
    }
}

extension AboutProductsRemote {
    func managedObject(context: NSManagedObjectContext, order: Int) -> NSManagedObject {
        // Create entity & set values
        let sellerContacts = NSEntityDescription.insertNewObject(forEntityName: "AboutProduct", into: context)
        (sellerContacts as? AboutProduct)?.update(from: self, order: order)
        // Return result
        return sellerContacts
    }
}
