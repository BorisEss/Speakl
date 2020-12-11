//
//  LanguageLevel.swift
//  stori
//
//  Created by Alex on 10.12.2020.
//

import UIKit

struct LanguageLevel: Decodable {
    var id: Int
    var name: String
    var shortcut: String
    var colorString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "long_name"
        case shortcut = "short_name"
        case colorString = "bg_color"
    }
    
    var color: UIColor {
        return UIColor.fromRgbaString(colorString) ?? .clear
    }
}
