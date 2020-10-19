//
//  UIView+Extensions.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 19.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
}
//class UIView_Extensions: UIView {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//        get {
//            if let color = layer.borderColor {
//                return UIColor(cgColor: color)
//            }
//            else {
//                return nil
//            }
//        }
//    }
//
//    @IBInspectable var borderWidth: CGFloat {
//        set {
//            layer.borderWidth = newValue
//        }
//        get {
//            return layer.borderWidth
//        }
//    }
//
//}
