//
//  TitlesRemote.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 10.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import CoreData

struct TitlesRemote {
    let title: String
    let img: String
    let imgTitle: String
    let productsTitle: String
    let productsTitle2: String
}

extension TitlesRemote: Codable {
    enum CodingKeys: String, CodingKey {
        case title, img, imgTitle, productsTitle, productsTitle2
    }
    /** Decode or set defaults */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = (try? values.decode(String.self, forKey: .title)) ?? ""
        img = (try? values.decode(String.self, forKey: .img)) ?? ""
        imgTitle = (try? values.decode(String.self, forKey: .imgTitle)) ?? ""
        productsTitle = (try? values.decode(String.self, forKey: .productsTitle)) ?? ""
        productsTitle2 = (try? values.decode(String.self, forKey: .productsTitle2)) ?? ""
    }
}

extension TitlesRemote {
    /** Get NSManagedObject for Group */
    func managedObject(context: NSManagedObjectContext) -> NSManagedObject {
        // Create entity & set values
        let titles = NSEntityDescription.insertNewObject(forEntityName: "Titles", into: context)
        (titles as? Titles)?.update(from: self)
        // Return result
        return titles
    }
}
