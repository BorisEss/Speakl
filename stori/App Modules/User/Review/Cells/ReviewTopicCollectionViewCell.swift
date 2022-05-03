//
//  ReviewTopicCollectionViewCell.swift
//  stori
//
//  Created by Alex on 28.04.2022.
//

import UIKit
import SDWebImage

class ReviewTopicCollectionViewCell: UICollectionViewCell, CustomCollectionViewCell {

    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var topicNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(topic: Topic) {
        topicImageView.sd_setImage(with: topic.imageUrl)
        topicNameLabel.text = topic.name
    }
    
}
