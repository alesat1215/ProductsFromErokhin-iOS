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
        guard let name = name, name.isEmpty,
              let phone = phone, phone.isEmpty,
              let address = address, address.isEmpty
        else {
            return ""
        }
        let separator = "\r\n"
        var result = ""
        result += separator + separator + name
        result += { if result.last != separator.last && !phone.isEmpty { return separator } else { return "" } }() + phone
        result += { if result.last != separator.last && !address.isEmpty { return separator } else { return "" } }() + address
        return result
    }
}
