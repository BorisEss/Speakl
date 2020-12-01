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
        // TODO: Add translation by selected language
//        if let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
//            #if DEBUG
//            return bundle.localizedString(forKey: self, value: ">> \(self) <<", table: "Strings")
//            #else
//            return bundle.localizedString(forKey: self, value: "\(self)", table: "Strings")
//            #endif
//        } else {
            #if DEBUG
            return Bundle.main.localizedString(forKey: self, value: ">> \(self) <<", table: "Strings")
            #else
            return Bundle.main.localizedString(forKey: self, value: "\(self)", table: "Strings")
            #endif
//        }
    }
    
    /// This function checks if current string is a valid email.
    ///
    /// - Returns: `Bool` value which specifies if current string is an email.
    ///
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
    
    /// This function checks if current string is a valid password.
    /// Password requirement is to have minimum 6 characters.
    ///
    /// - Returns: `Bool` value which specifies if current string corresponds to requirements.
    ///
    var isValidPassword: Bool {
        let checkRegex = "^.{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", checkRegex).evaluate(with: self)
    }
}
