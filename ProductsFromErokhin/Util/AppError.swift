//
//  AppError.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 04.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation

enum AppError: LocalizedError {
    case error(_ description: String?)
    
    // Need for print localizedDescription
    var errorDescription: String? {
        switch self {
        case .error(let error):
            return NSLocalizedString(error ?? "", comment: "")
        }
    }
}

extension AppError {
    static let unknown: AppError = .error("unknown")
    static let context: AppError = .error("context")
    static let group: AppError = .error("Group not found")
}
