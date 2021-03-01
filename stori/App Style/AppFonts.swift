//
//  AppFonts.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit

extension UIFont {
    static func IBMPlexSans(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "IBMPlexSans", size: size) ?? .systemFont(ofSize: size)
    }
    static func IBMPlexSansBold(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "IBMPlexSans-Bold", size: size) ?? .boldSystemFont(ofSize: size)
    }
    static func IBMPlexSansLightItalic(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "IBMPlexSans-LightItalic", size: size) ?? .boldSystemFont(ofSize: size)
    }
    static func sweetPea(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "Sweet_Pea", size: size) ?? .systemFont(ofSize: size)
    }
}
