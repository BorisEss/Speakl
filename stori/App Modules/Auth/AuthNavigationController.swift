//
//  AuthNavigationController.swift
//  stori
//
//  Created by Alex on 29.12.2020.
//

import UIKit

class AuthNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .black
        navigationBar.addShadow()
        navigationBar.setUpFont()
    }
}
