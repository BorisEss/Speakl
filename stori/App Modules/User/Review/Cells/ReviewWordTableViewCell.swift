//
//  ReviewWordTableViewCell.swift
//  stori
//
//  Created by Alex on 28.04.2022.
//

import UIKit
import Speech
import SDWebImage

class ReviewWordTableViewCell: UITableViewCell, CustomTableViewCell {

    var word: VocabularyWord?
    let synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var wordImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var pronunciationLabel: UILabel!
    @IBOutlet weak var listenButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func listenButtonPressed(_ sender: Any) {
        guard let word = word else { return }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                         mode: .spokenAudio,
                                         options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch { }
        let wordUtterance = AVSpeechUtterance(string: word.word)
        wordUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(wordUtterance)
    }
    
    func setUp(word: VocabularyWord) {
        self.word = word
        wordImageView.sd_setImage(with: URL(string: word.url ?? ""))
        wordLabel.text = word.word
        definitionLabel.text = word.definition
    }
}
