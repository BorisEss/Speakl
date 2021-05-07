//
//  LanguageLevel.swift
//  stori
//
//  Created by Alex on 10.12.2020.
//

import UIKit

struct LanguageLevel: Decodable, Equatable {
    var id: Int
    var name: String
    var shortcut: String?
    var colorString: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "long_name"
        case shortcut = "short_name"
        case colorString = "bg_color"
    }
    
    var color: UIColor {
        return UIColor.fromRgbaString(colorString ?? "") ?? .clear
    }
    
    var attributedShortcut: NSAttributedString {
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.IBMPlexSansBold(size: 12),
            .foregroundColor: UIColor.black
        ]
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.IBMPlexSans(size: 12),
            .foregroundColor: UIColor.black
        ]
        if !(shortcut ?? "").contains("HSK") {
            if let prefix = shortcut?.first,
               let suffix = shortcut?.dropFirst() {
                let finalString = NSMutableAttributedString(string: String(prefix),
                                                            attributes: boldAttributes)
                let secondString = NSAttributedString(string: String(suffix),
                                                      attributes: regularAttributes)
                finalString.append(secondString)
                return finalString
            }
        } else {
            return NSAttributedString(string: shortcut ?? "",
                                      attributes: regularAttributes)
        }
        return NSAttributedString()
    }
    
    static func == (lhs: LanguageLevel, rhs: LanguageLevel) -> Bool {
        return lhs.id == rhs.id
    }
}
