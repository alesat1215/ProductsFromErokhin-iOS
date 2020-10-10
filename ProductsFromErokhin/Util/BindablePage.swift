//
//  BindablePage.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 10.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class BindablePage<T: AnyObject>: UIViewController {
    /** Data model */
    weak var model: T?
    /** Save model */
    func bind(model: T) {
        self.model = model
    }

}
