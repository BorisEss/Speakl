//
//  UITextFieldExtension.swift
//  stori
//
//  Created by Alex on 25.11.2020.
//

import UIKit

extension UITextField {
    func validate() -> Bool {
        guard let fieldValue = text else { return false }
        if fieldValue.isEmpty {
            // TODO: Show error
            becomeFirstResponder()
            return false
        }
        return true
    }
    
    func validateEmail() -> Bool {
        if validate() {
            guard let fieldValue = text else { return false }
            if !fieldValue.isValidEmail {
                // TODO: Show invalid email
                becomeFirstResponder()
                return false
            }
            return true
        }
        return false
    }
    
    func validatePassword() -> Bool {
        if validate() {
            guard let fieldValue = text else { return false }
            if !fieldValue.isValidPassword {
                // TODO: Show invalid password
                becomeFirstResponder()
                return false
            }
            return true
        }
        return false
    }
}
