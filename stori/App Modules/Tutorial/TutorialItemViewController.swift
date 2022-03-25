//
//  TutorialItemViewController.swift
//  stori
//
//  Created by Alex on 23.12.2021.
//

import UIKit

class TutorialItemViewController: UIViewController {

    // MARK: - Variables
    var item: TutorialValue?
    
    // MARK: - IBOutlets
    @IBOutlet weak var tutorialIcon: UIImageView!
    @IBOutlet weak var tutorialLabel: UILabel!
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let item = item else {
            return
        }
        self.tutorialIcon.image = item.image
        self.tutorialLabel.text = item.description
    }

    // MARK: - Set Up Methods
    func setUp(_ value: TutorialValue) {
        self.item = value
    }
    
}
