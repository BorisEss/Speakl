//
//  RegularButton.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit

class RegularButton: UIButton {
    @IBInspectable var darkStyle: Bool = false {
        didSet {
            updateStyle()
        }
    }
    
    @IBInspectable var whiteStyle: Bool = false {
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
        cornerRadius = smallerSide / 2
        
        // Setting button colors
        setTitleColor(darkStyle ? .speaklWhite : .speaklWhite, for: .normal)
        if isEnabled {
            backgroundColor = darkStyle ? .speaklTextColor : .speaklAccentColor
            if whiteStyle {
                backgroundColor = .white
                setTitleColor(.black, for: .normal)
            }
        } else {
            backgroundColor = .speaklGray
        }
        
        // Setting disabled style
        setTitleColor(.speaklTextColor, for: .disabled)
        
        // Setting button font
        titleLabel?.font = UIFont.IBMPlexSansBold(size: titleLabel?.font.pointSize ?? 16)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        setNeedsDisplay()
    }
}
