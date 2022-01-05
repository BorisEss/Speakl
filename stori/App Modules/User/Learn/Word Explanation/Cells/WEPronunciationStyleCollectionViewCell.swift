//
//  WEPronunciationStyleCollectionViewCell.swift
//  stori
//
//  Created by Alex on 05.01.2022.
//

import UIKit

class WEPronunciationStyleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.font = .IBMPlexSansBold(size: 16)
            } else {
                titleLabel.font = .IBMPlexSans(size: 16)
            }
            layoutIfNeeded()
        }
    }
}
