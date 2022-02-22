//
//  SpeakAlertViewController.swift
//  stori
//
//  Created by Alex on 01.02.2022.
//

import UIKit
import Speech

class SpeakAlertViewController: UIViewController {

    var userText: String = ""
    var correctText: String = ""
    var definition: String = ""
    var userAudio: URL?
    var correctAudio: URL?
    var itIsLastWord: Bool = false
    var itIsCorrect: Bool = true
    
    var speakAgainCompletionHandler: (() -> Void)?
    var nextCompletionHandler: (() -> Void)?
    
    let synthesizer = AVSpeechSynthesizer()
    var player: AudioPlayer = AudioPlayer()
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var correctView: UIStackView!
    @IBOutlet weak var incorrectView: UIStackView!
    
    @IBOutlet weak var userAnswerIcon: UIImageView!
    @IBOutlet weak var userAnswerLabel: UILabel!
    
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var wordTranslationLabel: UILabel!
    
    @IBOutlet weak var speakAgainButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        correctView.isHidden = !itIsCorrect
        incorrectView.isHidden = itIsCorrect
        userAnswerLabel.text = userText
        correctAnswerLabel.text = correctText
        wordTranslationLabel.text = definition
        userAnswerIcon.image = UIImage(named: itIsCorrect ? "speaker_icon_correct" : "speaker_icon_incorrect")
        userAnswerLabel.textColor = itIsCorrect ? .tagGreen : .tagRed
        finishButton.isHidden = !itIsLastWord
        nextButton.isHidden = itIsLastWord
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func listenUserAnswerButtonPressed(_ sender: Any) {
        player.stop()
        if let userAudio = userAudio {
            player.load(url: userAudio)
            player.play()
        }
    }
    @IBAction func listenCorrectAnswerButtonPressed(_ sender: Any) {
        player.stop()
        if let currectAudio = correctAudio {
            player.load(url: currectAudio)
            player.play()
        } else {
            let wordUtterance = AVSpeechUtterance(string: correctText)
            wordUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(wordUtterance)
        }
    }
    
    @IBAction func speakAgainButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.speakAgainCompletionHandler?()
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.nextCompletionHandler?()
        }
    }
    @IBAction func finishButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.nextCompletionHandler?()
        }
    }
    
}
