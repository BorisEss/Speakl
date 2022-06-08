//
//  SpeakTableViewCell.swift
//  stori
//
//  Created by Alex on 18.02.2022.
//

import UIKit

class SpeakTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    
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

}
