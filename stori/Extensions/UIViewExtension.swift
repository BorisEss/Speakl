//
//  UIViewExtension.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit

// MARK: - UIView Extension Border / Corner
public extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set (newValue) { layer.borderColor = (newValue?.cgColor ?? tintColor.cgColor) }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set (newValue) { layer.borderWidth = newValue }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

// MARK: - UIView Extension Shadow
extension UIView {
    @IBInspectable var shadow: Bool {
        get { return layer.shadowRadius != 0 }
        set (newValue) {
            if newValue {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = cornerRadius
                self.layer.shadowColor = tintColor.cgColor
                self.layer.shadowRadius = 4
                self.layer.shadowOpacity = 0.35
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
            }
        }
    }
}

// MARK: - Custom Shadow extension
extension UIView {
    @IBInspectable var shadowColor: UIColor? {
        get { if let color = layer.shadowColor {
            return UIColor(cgColor: color)
        } else {
            return nil
        }
        }
        set (newValue) {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set (newValue) {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set (newValue) {
            self.layer.shadowOpacity = Float(newValue)
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set (newValue) {
            self.layer.shadowOffset = newValue
        }
    }
}

// MARK: - Fix view in container
extension UIView {
    func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0).isActive = true
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
