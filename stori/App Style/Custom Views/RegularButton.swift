//
//  RegularButton.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit

@IBDesignable
class RegularButton: UIButton {
    @IBInspectable var darkStyle: Bool = false {
        didSet {
            updateStyle()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateStyle()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateStyle()
    }
    
    private func updateStyle() {
        // Round corners for the button
        let smallerSide: CGFloat = frame.width < frame.height ? frame.width : frame.height
//        cornerRadius =
        cornerRadius = smallerSide / 2
//        layer.masksToBounds = false
        
        // Setting button colors
        setTitleColor(darkStyle ? .darkButtonTitle : .lightButtonTitle, for: .normal)
//        setBackgroundImage(UIImage.from(color: darkStyle ? .darkButtonBackground : .lightButtonBackground),
//                           for: .normal)
        if isEnabled {
            backgroundColor = darkStyle ? .darkButtonBackground : .lightButtonBackground
        } else {
            backgroundColor = .disabledButtonBackground
        }
        
        // Setting disabled style
        setTitleColor(.disabledButtonTitle, for: .disabled)
//        setBackgroundImage(UIImage.from(color: .disabledButtonBackground), for: .disabled)
        
        // Setting button font
        titleLabel?.font = UIFont.IBMPlexSansBold(size: titleLabel?.font.pointSize ?? 16)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        setNeedsDisplay()
    }
}
