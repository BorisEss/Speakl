//
//  CommentTableViewCell.swift
//  stori
//
//  Created by Alex on 14.04.2022.
//

import UIKit

class CommentTableViewCell: UITableViewCell, CustomTableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var commentTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(image: UIImage, name: String, comment: String, time: String) {
        userProfileImage.image = image
        userNameLabel.text = name
        userCommentLabel.text = comment
        commentTimeLabel.text = time
    }
}
