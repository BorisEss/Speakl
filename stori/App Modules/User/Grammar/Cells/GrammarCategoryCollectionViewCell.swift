//
//  GrammarCategoryCollectionViewCell.swift
//  stori
//
//  Created by Alex on 20.07.2022.
//

import UIKit

class GrammarCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setUp(_ category: GrammarCategory) {
        titleLabel.text = category.name
        iconImageView.image = UIImage(systemName: category.icon)
//        iconImageView.load(stringUrl: category.icon)
    }
}
