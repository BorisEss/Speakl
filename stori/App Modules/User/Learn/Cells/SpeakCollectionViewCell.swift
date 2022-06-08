//
//  SpeakCollectionViewCell.swift
//  stori
//
//  Created by Alex on 14.02.2022.
//

import UIKit

class SpeakCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    
    func setUp(word: SpeakWord) {
        if let hasAnswerdCorrect = word.hasAnsweredCorrect {
            cellView.backgroundColor = hasAnswerdCorrect ? .speaklGreen : .speaklRed
            wordLabel.textColor = .speaklWhite
        } else {
            cellView.backgroundColor = .clear
            wordLabel.textColor = .speaklTextColor
        }
        wordLabel.text = word.word
    }
    
//    func check(spokenWord: String) {
//
//        guard let labelText = wordLabel.text else { return }
//        guard !inputText.isEmpty,
//              !labelText.isEmpty else { return }
//        let mText = inputText.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//        if mText == labelText.uppercased() {
//            state = .correct
//            inputTextField.isEnabled = false
//            inputTextField.text = wordLabel.text
//            completion?()
//        } else {
//            state = .incorrect
//        }
//    }
    
}
