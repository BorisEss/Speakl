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
    
    @IBAction func createStoryButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func translateStoryButtonPressed(_ sender: Any) {
        
    }
    
    private func setUpLanguage() {
        title = "Teacher Network"
        createStoryLabel.text = "Create My Story"
        translateStoryLabel.text = "Translate Existing Stories"
    }
}
