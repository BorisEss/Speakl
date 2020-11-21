//
//  UIGradientView.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit

@IBDesignable
class UIGradientView: UIView {
    
    @IBInspectable var startColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var endColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
