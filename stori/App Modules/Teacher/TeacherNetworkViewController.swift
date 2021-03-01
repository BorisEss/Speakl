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
    
    private func setUpLanguage() {
        title = "teacher_network_title".localized
        createStoryLabel.text = "teacher_network_create_story".localized
        translateStoryLabel.text = "teacher_network_translate_story".localized
    }
}
