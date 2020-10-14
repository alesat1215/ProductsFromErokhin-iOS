//
//  AboutAppRemote.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 14.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

struct AboutAppRemote {
    let privacy: String
    let version: String
    let build: String
    let appStore: String
}

extension AboutAppRemote: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case privacy, version, build, appStore
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        privacy = (try? values.decode(String.self, forKey: .privacy)) ?? ""
        version = (try? values.decode(String.self, forKey: .version)) ?? ""
        build = (try? values.decode(String.self, forKey: .build)) ?? ""
        appStore = (try? values.decode(String.self, forKey: .appStore)) ?? ""
    }
}

extension AboutAppRemote {
    func managedObject(context: NSManagedObjectContext, order: Int) -> NSManagedObject {
        // Create entity & set values
        let aboutApp = NSEntityDescription.insertNewObject(forEntityName: "AboutApp", into: context)
        (aboutApp as? AboutApp)?.update(from: self, order: order)
        // Return result
        return aboutApp
    }
}
