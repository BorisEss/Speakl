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
            Toast.error("common_empty_field".localized)
            becomeFirstResponder()
            return false
        }
        return true
    }
    
    func validateEmail() -> Bool {
        if validate() {
            guard let fieldValue = text else { return false }
            if !fieldValue.isValidEmail {
                Toast.error("auth_vc_error_wrong_email_format".localized)
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
                Toast.error("common_wrong_password_format".localized)
                becomeFirstResponder()
                return false
            }
            return true
        }
        return false
    }
}
