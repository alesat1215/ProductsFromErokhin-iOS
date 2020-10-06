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
    let groupRemoteResult = [GroupRemote(name: "", products: [])]
    let titlesRemoteResult = TitlesRemote(title: "", img: "", imgTitle: "", productsTitle: "", productsTitle2: "")
    let orderWarningRemoteResult = OrderWarningRemote(text: "", groups: [])
    let sellerContactsRemoteResult = SellerContactsRemote(phone: "", address: "")
    let error = AppError.error("Unknown type for JSONDecoderMock")
    
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if type == [GroupRemote].self {
            return groupRemoteResult as! T
        }
        if type == TitlesRemote.self {
            return titlesRemoteResult as! T
        }
        if type == OrderWarningRemote.self {
            return orderWarningRemoteResult as! T
        }
        if type == SellerContactsRemote.self {
            return sellerContactsRemoteResult as! T
        }
        
        throw error
    }
}
