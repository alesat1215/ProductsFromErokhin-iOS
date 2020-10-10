//
//  BindablePage.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 10.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

class BindablePage<T: AnyObject>: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    
    weak var model: T?
    
    func bind(model: T) {
        self.model = model
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
