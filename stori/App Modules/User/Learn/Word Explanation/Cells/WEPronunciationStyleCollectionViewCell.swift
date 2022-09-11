//
//  WEPronunciationStyleCollectionViewCell.swift
//  stori
//
//  Created by Alex on 05.01.2022.
//

import UIKit

class WEPronunciationStyleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                cellView.borderWidth = 0
                cellView.backgroundColor = .speaklViolet
                titleLabel.textColor = .speaklWhite
            } else {
                cellView.borderWidth = 2
                cellView.backgroundColor = .clear
                titleLabel.textColor = .speaklTextColor
            }
            layoutIfNeeded()
        }
    }
}
