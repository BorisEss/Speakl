//
//  UIApplicationExtension.swift
//  stori
//
//  Created by Alex on 21.12.2020.
//

import UIKit

extension UIApplication {
    class func getTopViewController(base: UIViewController? = nil) -> UIViewController? {
        let defaultBase = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let currentBase = base == nil ? defaultBase : base
        if let nav = currentBase as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = currentBase as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = currentBase?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return currentBase
    }
}
