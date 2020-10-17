//
//  GradientNavigationBar.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 17.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit

@IBDesignable
class GradientNavigationController: UINavigationController {
    
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
    
    /** Set nav bar gradient background image */
    private func updateView() {
        // Get gradient layer
        let _gradient = gradient()
        // Create image & set it to nav bar background
        UIGraphicsBeginImageContext(_gradient.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            _gradient.render(in: context)
            if let gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch) {
                navigationBar.setBackgroundImage(gradientImage, for: .default)
            }
        }
        UIGraphicsEndImageContext()
    }
    /** - Returns: gradient layer for colors */
    private func gradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [firstColor, secondColor]
            .map { $0.cgColor }
        if (isHorizontal) {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint (x: 1, y: 0.5)
         } else {
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint (x: 0.5, y: 1)
         }
        return gradient
    }

}
