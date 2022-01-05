//
//  SelectedWordExplanationViewController.swift
//  stori
//
//  Created by Alex on 04.01.2022.
//

import UIKit

class SelectedWordExplanationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
