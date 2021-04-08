//
//  InterestTableViewCell.swift
//  stori
//
//  Created by Alex on 07.04.2021.
//

import UIKit

class InterestTableViewCell: UITableViewCell, CustomTableViewCell {

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
        iconView.cornerRadius = InterestTableViewCell.height/2
        iconHeightConstraint.constant = InterestTableViewCell.height
    }

    func setUp(interest: Interest) {
        self.interest = interest
        iconImageView.load(url: interest.imageUrl)
        nameLabel.text = interest.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        checkMarkView.isHidden = !selected
        nameUnderlineView.isHidden = !selected
        iconImageView.isHidden = selected
    }
}
