//
//  Profile.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 08.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

extension Profile: Ordered {
    /** - Returns: delivery info for message */
    func delivery() -> String {
        if name?.isEmpty ?? true,
           phone?.isEmpty ?? true,
           address?.isEmpty ?? true
        {
            return ""
        }
        var result = "\r\n\r\n" + (name ?? "")
        result += addFieldToResult(result, field: phone ?? "")
        result += addFieldToResult(result, field: address ?? "")
        return result
    }
    /** - Returns: string with separator for field */
    private func addFieldToResult(_ result: String, field: String, separator: String = "\r\n") -> String {
        if !result.hasSuffix(separator) && !field.isEmpty {
            return separator + field
        }
        return field
    }
}
