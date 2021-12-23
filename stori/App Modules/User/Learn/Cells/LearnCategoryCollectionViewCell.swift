//
//  LearnCategoryCollectionViewCell.swift
//  stori
//
//  Created by Alex on 07.12.2021.
//

import UIKit

class LearnCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconSectionView: UIView!
    @IBOutlet weak var iconView: UIImageView!
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
    
    func setUp(title: String, icon: UIImage? = nil) {
        iconSectionView.isHidden = icon == nil
        titleLabel.text = title
    }
    
}
