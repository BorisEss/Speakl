//
//  EditPersonalInfoViewController.swift
//  stori
//
//  Created by Alex on 26.04.2021.
//

import UIKit

class EditPersonalInfoViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    private func setUpLanguage() {
        title = "edit_personal_info_title".localized
    }
    
    private func loadData() {
        usernameLabel.text = Storage.shared.currentUser?.username
        emailLabel.text = Storage.shared.currentUser?.email
    }
}
