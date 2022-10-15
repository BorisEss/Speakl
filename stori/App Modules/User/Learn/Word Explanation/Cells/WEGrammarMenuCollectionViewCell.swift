//
//  WEGrammarMenuCollectionViewCell.swift
//  stori
//
//  Created by Alex on 15.10.2022.
//

import UIKit

class WEGrammarMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .speaklBlueSolid : .speaklTextColor
        }
    }
}
