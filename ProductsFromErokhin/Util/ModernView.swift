//
//  ModernView.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 16.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

@IBDesignable
class ModernView: UIView {
    // MARK: - Gradient
    @IBInspectable var firstColor: UIColor = UIColor.clear {
       didSet {
           updateGradient()
        }
     }
     @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateGradient()
        }
    }
        
    private func updateGradient() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = [firstColor, secondColor]
            .map { $0.cgColor }
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
         } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
         }
    }
    
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    // MARK: - Border
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
    
    // MARK: - Corner
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    
}
