//
//  JSONDecoderMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 18.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
@testable import ProductsFromErokhin

class JSONDecoderMock: JSONDecoder {
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if type == [GroupRemote].self {
            return [GroupRemote(name: "", products: [])] as! T
        }
        if type == TitlesRemote.self {
            return TitlesRemote(title: "", img: "", imgTitle: "", productsTitle: "", productsTitle2: "") as! T
        }
        if type == OrderWarningRemote.self {
            return OrderWarningRemote(text: "", groups: []) as! T
        }
        if type == SellerContactsRemote.self {
            return SellerContactsRemote(phone: "", address: "") as! T
        }
        
        throw AppError.error("Unknown type for JSONDecoderMock")
    }
}
