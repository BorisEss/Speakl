//
//  ReviewTrainingViewController.swift
//  stori
//
//  Created by Alex on 01.05.2022.
//

import UIKit

class ReviewTrainingViewController: UIViewController {

    var words: [VocabularyWord] = []
    var level: ReviewLevel = .fullVocabulary
    
    lazy var gameVc: ReviewTrainingGameViewController? = nil
    lazy var scoreVc: ReviewTrainingScoreViewController? = nil
    
    @IBOutlet weak var gameContainerView: UIView!
    @IBOutlet weak var scoreContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameContainerView.isHidden = false
        scoreContainerView.isHidden = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.scoreVc?.loadScreen(words: self.words.count, correctAnswers: 10)
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? ReviewTrainingGameViewController {
            gameVc = nextVc
            switch level {
            case .easy:
                nextVc.words = Array(words.shuffled().prefix(10))
            case .normal:
                nextVc.words = Array(words.shuffled().prefix(30))
            case .fullVocabulary:
                nextVc.words = words.shuffled()
            }
            nextVc.showFinish = { [weak self] wordsCount, correctAnswers in
                self?.gameContainerView.isHidden = true
                self?.scoreContainerView.isHidden = false
                self?.scoreVc?.loadScreen(words: wordsCount, correctAnswers: correctAnswers)
            }
        }
        if let nextVc = segue.destination as? ReviewTrainingScoreViewController {
            scoreVc = nextVc
            nextVc.retryCallback = { [weak self] in
                 print("Retry")
            }
        }
    }
}
