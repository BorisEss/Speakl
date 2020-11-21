//
//  StringExtension.swift
//  stori
//
//  Created by Alex on 21.11.2020.
//

import Foundation

extension String {
    /// This function loads string from `Localization` File for multiple languages applications.
    ///
    /// - Returns: `String` value which is the string in Phone Language.
    ///
    var localized: String {
        #if DEBUG
        return Bundle.main.localizedString(forKey: self, value: ">> \(self) <<", table: "Strings")
        #else
        return Bundle.main.localizedString(forKey: self, value: "\(self)", table: "Strings")
        #endif
    }
}
