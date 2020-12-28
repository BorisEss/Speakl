//
//  UIViewControllerExtension.swift
//  stori
//
//  Created by Alex on 22.11.2020.
//

import UIKit

extension UIViewController {
    /// This function hides the keyboard.
    ///
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// This function overrides touches method. Keyboard will be dismissed then touch began on screen.
    ///
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: Email Extension
extension UIViewController {
    /// This function presents Email View Controller to send an email from the app.
    ///
    /// - Parameter emailAddress: Email Address which will be loaded inside the new email screen.
    ///
    func sendEmail(emailAddress: String) {
        if let url = URL(string: "mailto:\(emailAddress)") {
            UIApplication.shared.open(url)
        }
    }
}
