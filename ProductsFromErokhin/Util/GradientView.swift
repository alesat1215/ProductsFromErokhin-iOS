//
//  GradientView.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 16.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
       didSet {
           updateView()
        }
     }
     @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
        
    private func updateView() {
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
}
