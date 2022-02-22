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
            cellView.backgroundColor = hasAnswerdCorrect ? .tagGreen : .tagRed
            wordLabel.textColor = .white
        } else {
            cellView.backgroundColor = .clear
            wordLabel.textColor = .textGray
        }
        wordLabel.text = word.word
    }

}
