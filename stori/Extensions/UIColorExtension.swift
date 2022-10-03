//
//  UIColorExtension.swift
//  stori
//
//  Created by Alex on 11.12.2020.
//

import UIKit

extension UIColor {
    static func fromRgbaString(_ string: String) -> UIColor? {
        let prefixTrimmedString = string.dropFirst(5)
        let sufixTrimmedString = prefixTrimmedString.dropLast()
        let values = sufixTrimmedString.split(separator: ",")
        let numberValues: [Double] = values.map({ Double($0) ?? 0 })
        if numberValues.count == 4 {
            let red = CGFloat(numberValues[0]/255)
            let green = CGFloat(numberValues[1]/255)
            let blue = CGFloat(numberValues[2]/255)
            let alpha = CGFloat(numberValues[3])
            return(UIColor(red: red, green: green, blue: blue, alpha: alpha))
        }
        return nil
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex
            .replacingOccurrences(of: "#", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let rInt = Int(color >> 16) & mask
        let gInt = Int(color >> 8) & mask
        let bInt = Int(color) & mask
        let red   = CGFloat(rInt) / 255.0
        let green = CGFloat(gInt) / 255.0
        let blue  = CGFloat(bInt) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func hexStringFromColor() -> String {
        let components = self.cgColor.components
        let rFloat: CGFloat = components?[0] ?? 0.0
        let gFloat: CGFloat = components?[1] ?? 0.0
        let bFloat: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX",
                                    lroundf(Float(rFloat * 255)),
                                    lroundf(Float(gFloat * 255)),
                                    lroundf(Float(bFloat * 255)))
        return hexString
     }
}
