//
//  JoinTNSelectUserTypeViewController.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit

enum JoinTNUserType: Int {
    case student = 0
    case master = 1
    case teacher = 2
}

class JoinTNSelectUserTypeViewController: UIViewController {
    
    private var segueToNextScreen = "contnueToUpload"
    private var userType: JoinTNUserType?

    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var masterLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToNextScreen,
           let nextVc = segue.destination as? JoinTNDocumentListViewController {
            nextVc.userType = userType
        }
    }

    @IBAction func itemPressed(_ sender: UIButton) {
        userType = JoinTNUserType(rawValue: sender.tag)
        if userType != nil {
            performSegue(withIdentifier: segueToNextScreen, sender: nil)
        }
    }
    
    func setUpLanguage() {
        title = "join_tn_usertype_navbar_title".localized
        studentLabel.text = "join_tn_usertype_student".localized
        masterLabel.text = "join_tn_usertype_master".localized
        teacherLabel.text = "join_tn_usertype_teacher".localized
    }
}
