//
//  ReviewTrainingGameViewController.swift
//  stori
//
//  Created by Alex on 01.05.2022.
//

import UIKit

class ReviewTrainingGameViewController: UIViewController {

    var words: [VocabularyWord] = []
    var currentWord: Int = 0 {
        didSet {
            if !words.isEmpty {
                progressBarView.setProgress(Float(currentWord)/Float(words.count - 1),
                                            animated: true)
            }
            wordLabel.text = words[currentWord].word
            answer1Button.setWord(word: words[currentWord].word)
            answer2Button.setWord(word: words[currentWord].word)
            answer3Button.setWord(word: words[currentWord].word)
            answer4Button.setWord(word: words[currentWord].word)
            checkButton.isEnabled = false
        }
    }
    var correctAnswers: Int = 0
    
    var showFinish: ((_ wordsCount: Int, _ correctAnswers: Int) -> Void)?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet weak var wordLabel: UnderlinedLabel!
    @IBOutlet weak var answer1Button: ReviewWordButton!
    @IBOutlet weak var answer2Button: ReviewWordButton!
    @IBOutlet weak var answer3Button: ReviewWordButton!
    @IBOutlet weak var answer4Button: ReviewWordButton!
    @IBOutlet weak var checkButton: RegularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentWord = 0
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        Vibration().light()
        if answer1Button.isSelected() { answer1Button.clear() }
        if answer2Button.isSelected() { answer2Button.clear() }
        if answer3Button.isSelected() { answer3Button.clear() }
        if answer4Button.isSelected() { answer4Button.clear() }
        switch sender.tag {
        case 1: answer1Button.setSelected()
        case 2: answer2Button.setSelected()
        case 3: answer3Button.setSelected()
        case 4: answer4Button.setSelected()
        default: break
        }
        checkButton.isEnabled = true
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        if answer1Button.isEnabled {
            answer1Button.isEnabled = false
            answer2Button.isEnabled = false
            answer3Button.isEnabled = false
            answer4Button.isEnabled = false
            checkButton.setTitle("Continue", for: .normal)
            if answer1Button.isSelected() { answer1Button.setCorrect() }
            if answer2Button.isSelected() { answer2Button.setCorrect() }
            if answer3Button.isSelected() { answer3Button.setCorrect() }
            if answer4Button.isSelected() { answer4Button.setCorrect() }
            correctAnswers += 1
        } else {
            if currentWord == words.count -  1 {
                showFinish?(words.count, correctAnswers)
                currentWord = 0
                correctAnswers = 0
            } else {
                currentWord += 1
            }
            answer1Button.isEnabled = true
            answer2Button.isEnabled = true
            answer3Button.isEnabled = true
            answer4Button.isEnabled = true
        }
    }
}
