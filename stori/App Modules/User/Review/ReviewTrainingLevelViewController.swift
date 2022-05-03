//
//  ReviewTrainingLevelViewController.swift
//  stori
//
//  Created by Alex on 01.05.2022.
//

import UIKit

enum ReviewLevel {
    case easy
    case normal
    case fullVocabulary
}

class ReviewTrainingLevelViewController: UIViewController {

    lazy var completion: ((_ level: ReviewLevel) -> Void)? = nil
    
    var wordCount: Int = 0
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var easyViewSection: UIView!
    @IBOutlet weak var normalViewSection: UIView!
    @IBOutlet weak var fullVocabularyViewSection: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.alpha = 0
        
        switch wordCount {
        case 0...10:
            easyViewSection.isHidden = true
            normalViewSection.isHidden = true
        case 11...29:
            normalViewSection.isHidden = true
        default: break
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !cardView.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = .black.withAlphaComponent(0.6)
            }
            UIView.animate(withDuration: 0.3) {
                self.closeButton.alpha = 1
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        view.backgroundColor = .clear
        closeButton.alpha = 0
        dismiss(animated: true)
    }
    
    @IBAction func levelButtonPressed(_ sender: UIButton) {
        view.backgroundColor = .clear
        closeButton.alpha = 0
        dismiss(animated: true) { [weak self] in
            switch sender.tag {
            case 0: self?.completion?(.easy)
            case 1: self?.completion?(.normal)
            case 2: self?.completion?(.fullVocabulary)
            default: break
            }
        }
    }
}
