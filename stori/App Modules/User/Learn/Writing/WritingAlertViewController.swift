//
//  WritingAlertViewController.swift
//  stori
//
//  Created by Alex on 26.01.2022.
//

import UIKit
import Speech

class WritingAlertViewController: UIViewController {

    var word: WritingWord?
    
    let synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var correctView: UIStackView!
    @IBOutlet weak var incorrectView: UIStackView!
    
    @IBOutlet weak var wordButton: UIButton!
    
    @IBOutlet weak var wordTranslationLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let word = word else {
            return
        }
        wordButton.setTitle(word.word, for: .normal)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    @IBAction func wordButtonPressed(_ sender: Any) {
        guard let word = word else {
            return
        }
        let wordUtterance = AVSpeechUtterance(string: word.word)
        wordUtterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        synthesizer.speak(wordUtterance)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        if sender.title(for: .normal) == "Add to ⭐️" {
            sender.setTitle("Remove ⭐️", for: .normal)
        } else {
            sender.setTitle("Add to ⭐️", for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !cardView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
}
