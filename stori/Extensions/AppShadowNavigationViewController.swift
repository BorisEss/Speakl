//
//  AppShadowNavigationViewController.swift
//  stori
//
//  Created by Alex on 28.09.2021.
//

import UIKit

class AppShadowNavigationViewController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage(named: "navbarShadow")
            appearance.titleTextAttributes = [.font: UIFont.IBMPlexSansBold(size: 16),
                                              .foregroundColor: UIColor.textBlack]
            
            let backButtonAppearence = UIBarButtonItemAppearance()
            backButtonAppearence.normal.titleTextAttributes = [.font: UIFont.IBMPlexSansBold(size: 14),
                                                               .foregroundColor: UIColor.white]
            appearance.backButtonAppearance = backButtonAppearence
            // Customizing our navigation bar
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = .white
            navigationBar.backgroundColor = .white
            navigationBar.tintColor = .textBlack
            navigationBar.shadowImage = UIImage(named: "navbarShadow")
            navigationBar.titleTextAttributes = [
                .font: UIFont.IBMPlexSansBold(size: 16),
                .foregroundColor: UIColor.textBlack
            ]
            
            navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
            navigationBar.layer.shadowOpacity = 0.2
            navigationBar.layer.shadowRadius = 8
            navigationBar.layer.shadowOffset = CGSize(width: 0, height: 8)
        }
    }

}
