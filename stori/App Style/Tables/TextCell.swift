//
//  TextCell.swift
//  stori
//
//  Created by Alex on 28.08.2022.
//

import UIKit
import SpreadsheetView

class TextCell: Cell {
    
    static let identifier: String = "TextCell"
    
    let colorView = UIView()
    let label = UILabel()

    override var frame: CGRect {
        didSet {
            colorView.frame = bounds
            label.frame = bounds.insetBy(dx: 4, dy: 2)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView

        colorView.frame = bounds
        colorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(colorView)
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp(color: UIColor,
               roundedCorners: UIRectCorner = [],
               radius: CGFloat = 0,
               text: String?,
               textAlignment: NSTextAlignment = .center) {
        DispatchQueue.main.async {
            self.label.textAlignment = textAlignment
            self.colorView.roundCorners(corners: roundedCorners, radius: radius)
            self.colorView.backgroundColor = color
            self.setUpLabelWith(text: text ?? "")
        }
    }
    
    private func setUpLabelWith(text: String) {
        let prefixText = text.split(separator: "<")
        if prefixText.count > 1 {
            let prefix = prefixText[0]
            let suffixText = prefixText[1].split(separator: ">")
            let middle = suffixText[0]
            let attrs1 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                          NSAttributedString.Key.foregroundColor: UIColor.white]
            let attrs2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                          NSAttributedString.Key.foregroundColor: UIColor.speaklRedSoft]
            let attributedString1 = NSMutableAttributedString(string: String(prefix), attributes: attrs1)
            let attributedString2 = NSMutableAttributedString(string: String(middle), attributes: attrs2)
            
            attributedString1.append(attributedString2)

            if suffixText.count > 1 {
                let suffix = suffixText[1]
                
                let attributedString3 = NSMutableAttributedString(string: String(suffix), attributes: attrs1)

                attributedString1.append(attributedString3)
            }
            label.attributedText = attributedString1
        } else {
            let newText = text.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
            label.text = newText
        }
    }
    
}
