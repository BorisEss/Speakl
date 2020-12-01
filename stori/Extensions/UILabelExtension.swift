//
//  UILabelExtension.swift
//  stori
//
//  Created by Alex on 24.11.2020.
//

import UIKit

extension UILabel {
    func underline(isShown: Bool = true) {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.underlineColor,
                                          value: isShown ? UIColor.accentColor : .clear,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}
