//
//  VocabularyItemTableViewCell.swift
//  stori
//
//  Created by Alex on 30.01.2021.
//

import UIKit

class VocabularyItemTableViewCell: UITableViewCell, CustomTableViewCell {

    var word: VocabularyWord?
    
    static var height: CGFloat = 96
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
        guard let word = word else { return }
        setUp(word: word)
    }
    
    func setUp(word: VocabularyWord) {
        self.word = word
        titleLabel.text = word.word
        subtitleLabel.text = word.definition
    }
}
