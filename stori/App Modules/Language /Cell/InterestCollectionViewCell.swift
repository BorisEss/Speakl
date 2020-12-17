//
//  InterestCollectionViewCell.swift
//  stori
//
//  Created by Alex on 15.12.2020.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell, CustomCollectionViewCell {
    
    static var height: CGFloat = 40
    
    private var interest: Interest?
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var checkMarkView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameUnderlineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let interest = interest {
            setUp(interest: interest)
        }
        iconView.cornerRadius = InterestCollectionViewCell.height/2
        iconHeightConstraint.constant = InterestCollectionViewCell.height
    }

    func setUp(interest: Interest) {
        self.interest = interest
        iconImageView.load(url: interest.imageUrl)
        nameLabel.text = interest.name
    }
    
    override var isSelected: Bool {
        didSet {
            checkMarkView.isHidden = !isSelected
            nameUnderlineView.isHidden = !isSelected
            iconImageView.isHidden = isSelected
        }
    }
}
