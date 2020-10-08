//
//  Profile.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

extension Profile: Ordered {
    func delivery() -> String {
        guard let name = name,
              let phone = phone,
              let address = address
        else {
            return ""
        }
        if name.isEmpty, phone.isEmpty, address.isEmpty {
            return ""
        }
//        let separator = "\r\n"
//        var result = ""
        var result = "\r\n\r\n" + name
//        result += { if !result.hasSuffix(separator) && !phone.isEmpty { return separator } else { return "" } }() + phone
//        result += { if !result.hasSuffix(separator) && !address.isEmpty { return separator } else { return "" } }() + address
        result += addFieldToResult(result, field: phone)
        result += addFieldToResult(result, field: address)
        return result
    }
    
    private func addFieldToResult(_ result: String, field: String, separator: String = "\r\n") -> String {
//        { if !result.hasSuffix(separator) && !field.isEmpty { return separator } else { return "" } }() + field
        if !result.hasSuffix(separator) && !field.isEmpty {
            return separator + field
        }
        return field
    }
}
