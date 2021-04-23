//
//  Number.swift
//  stori
//
//  Created by Alex on 21.04.2021.
//

import Foundation

class Number {
    static func format(price: Double, locale: Locale = Locale.current) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = locale
        if let priceString = currencyFormatter.string(from: NSNumber(value: price)) {
            return priceString
        } else {
            return "\(price) \(locale.currencySymbol ?? "")"
        }
    }
}
