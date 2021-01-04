//
//  UINavigationBarExtension.swift
//  stori
//
//  Created by Alex on 29.12.2020.
//

import UIKit

extension UINavigationBar {
    func addShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 8)
        removeUnderline()
    }
    func removeUnderline() {
        shadowImage = UIImage()
        layoutIfNeeded()
    }
    func setUpFont() {
        titleTextAttributes = [NSAttributedString.Key.font: UIFont.IBMPlexSansBold(size: 16)]
    }
}
