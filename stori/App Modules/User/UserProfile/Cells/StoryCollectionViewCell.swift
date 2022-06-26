//
//  StoryCollectionViewCell.swift
//  stori
//
//  Created by Alex on 20.06.2022.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell, CustomCollectionViewCell {

    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storyCoverView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        storyCoverView.load(stringUrl: "https://i.ibb.co/Yd5G7LF/the-californian-s-tale.jpg")
    }

}
