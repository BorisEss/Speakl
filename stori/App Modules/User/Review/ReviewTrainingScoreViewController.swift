//
//  ReviewTrainingScoreViewController.swift
//  stori
//
//  Created by Alex on 01.05.2022.
//

import UIKit

class ReviewTrainingScoreViewController: UIViewController {
    
    var retryCallback: (() -> Void)?
    
    var words: Int = 0
    var correctAnswers: Int = 0

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var smallCircleView: UIView!
    @IBOutlet weak var smallCircleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediumCircleView: UIView!
    @IBOutlet weak var mediumCircleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var largeCircleView: UIView!
    @IBOutlet weak var largeCircleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var retryButton: RegularButton!
    @IBOutlet weak var finishButton: RegularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearScreen()
    }
    
    @IBAction func retryButtonPressed(_ sender: Any) {
        retryCallback?()
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func loadScreen(words: Int, correctAnswers: Int) {
        self.words = words
        self.correctAnswers = correctAnswers
        loadScoreScreen()
    }
    
    func clearScreen() {
        smallCircleWidthConstraint.constant = 0
        mediumCircleWidthConstraint.constant = 0
        largeCircleWidthConstraint.constant = 0
        countLabel.text = nil
        titleLabel.text = nil
        retryButton.isHidden = true
        finishButton.isHidden = true
        finishButton.darkStyle = true
    }
    
    private func loadScoreScreen() {
        guard words != 0 else { return }
        let percentage: Double = Double(correctAnswers) / Double(words)
        var smallCircleSize, mediumCircleSize, largeCircleSize: Double
        finishButton.darkStyle = percentage != 1
        finishButton.isHidden = false
        retryButton.isHidden = percentage == 1
        finishButton.cornerRadius = 25
        retryButton.cornerRadius = 25
        if percentage < 0.4 {
            // Bad score
            titleLabel.text = "You can do much better"
            smallCircleSize = view.frame.width * 0.45
            mediumCircleSize = view.frame.width * 0.6
            largeCircleSize = view.frame.width * 0.75
        } else if percentage >= 0.4, percentage < 1 {
            // Normal score
            titleLabel.text = "Not bad"
            smallCircleSize = view.frame.width * 0.55
            mediumCircleSize = view.frame.width * 0.7
            largeCircleSize = view.frame.width * 0.9
        } else {
            // Great score
            titleLabel.text = "Great!"
            smallCircleSize = view.frame.width * 0.6
            mediumCircleSize = view.frame.width * 0.8
            largeCircleSize = view.frame.width * 1.1
        }
        smallCircleView.backgroundColor = UIColor(named: percentage <= 0.1 ? "Review Gray" : "AccentColor")
        mediumCircleView.backgroundColor = UIColor(named: percentage < 0.4 ? "Review Gray" : "AccentColor")
        largeCircleView.backgroundColor = UIColor(named: percentage < 1 ? "Review Gray" : "AccentColor")
        UIView.animate(withDuration: 0.6, delay: 0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 5,
                       options: [.curveEaseInOut]) {
            self.smallCircleWidthConstraint.constant = smallCircleSize
            self.mediumCircleWidthConstraint.constant = mediumCircleSize
            self.largeCircleWidthConstraint.constant = largeCircleSize
            self.smallCircleView.cornerRadius = smallCircleSize/2
            self.mediumCircleView.cornerRadius = mediumCircleSize/2
            self.largeCircleView.cornerRadius = largeCircleSize/2
            self.view.layoutSubviews()
        } completion: { _ in
            self.countLabel.text = "\(self.correctAnswers)/\(self.words)"
        }
    }
}
