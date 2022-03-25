//
//  WordCollectionViewCell.swift
//  stori
//
//  Created by Alex on 24.03.2022.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell, CustomCollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    
    func setUp(word: String) {
//        if let hasAnswerdCorrect = word.hasAnsweredCorrect {
//            cellView.backgroundColor = hasAnswerdCorrect ? .tagGreen : .tagRed
//            wordLabel.textColor = .white
//        } else {
            cellView.backgroundColor = .white
            wordLabel.textColor = .textGray
//        }
//        wordLabel.text = word.word
        wordLabel.text = word
    }

}
