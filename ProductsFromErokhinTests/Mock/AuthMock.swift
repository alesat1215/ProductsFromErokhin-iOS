//
//  AuthMock.swift
//  ProductsFromErokhinTests
//
//  Created by Alexander Satunin on 06.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseAuth
@testable import ProductsFromErokhin

class AuthMock: AuthMethods {
    var completion: AuthDataResultCallback?
    func signInAnonymously(completion: AuthDataResultCallback?) {
        self.completion = completion
    }
}
