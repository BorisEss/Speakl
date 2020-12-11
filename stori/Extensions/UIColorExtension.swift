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
}
