//
//  TutorialViewController.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit

class TutorialViewController: UIViewController {
    
    // MARK: - Variables
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: RegularButton!
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? TutorialPagesViewController {
            nextVc.tutorialPagesDelegate = self
        }
        super.prepare(for: segue, sender: sender)
    }
    
    // MARK: - Button Actions
    @IBAction func nextButtonPressed(_ sender: Any) {
        DefaultSettings.finishedTutorial = true
        Router.load()
    }
    
    // MARK: - Set Up
    private func setUpLanguage() {
        nextButton.setTitle("start_tutorial_vc_button_title_start".localized, for: .normal)
    }
}

// MARK: - TutorialPagesViewControllerDelegate
extension TutorialViewController: TutorialPagesViewControllerDelegate {
    func didChangeIndex(index: Int) {
        currentPage = index
    }
}
