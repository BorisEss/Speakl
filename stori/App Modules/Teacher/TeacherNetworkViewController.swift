//
//  TeacherNetworkViewController.swift
//  stori
//
//  Created by Alex on 21.12.2020.
//

import UIKit

class TeacherNetworkViewController: UIViewController {
    
    @IBOutlet weak var createStoryLabel: UILabel!
    @IBOutlet weak var translateStoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func setUpLanguage() {
        title = "teacher_network_title".localized
        createStoryLabel.text = "teacher_network_create_story".localized
        translateStoryLabel.text = "teacher_network_translate_story".localized
    }
}
