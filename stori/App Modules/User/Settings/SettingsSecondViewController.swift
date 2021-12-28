//
//  SettingsSecondViewController.swift
//  stori
//
//  Created by Alex on 28.12.2021.
//

import UIKit

class SettingsSecondViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationController?.popViewController(animated: false)
    }

}
