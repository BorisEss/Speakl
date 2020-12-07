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

extension UIViewController {
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        return nil
    }
}
