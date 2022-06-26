//
//  UserProfileViewController.swift
//  stori
//
//  Created by Alex on 13.04.2022.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var isTeacher: Bool = true

    var studentVc: StudentProfileViewController?
    var teacherVc: TeacherProfileViewController?
    
    @IBOutlet weak var studentProfileContainer: UIView!
    @IBOutlet weak var teacherProfileContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentProfileContainer.isHidden = isTeacher
        teacherProfileContainer.isHidden = !isTeacher
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? StudentProfileViewController {
            studentVc = nextVc
        }
        if let nextVc = segue.destination as? TeacherProfileViewController {
            teacherVc = nextVc
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
