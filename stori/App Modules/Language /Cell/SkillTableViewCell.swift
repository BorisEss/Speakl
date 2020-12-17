//
//  SkillTableViewCell.swift
//  stori
//
//  Created by Alex on 08.12.2020.
//

import UIKit

class SkillTableViewCell: UITableViewCell, CustomTableViewCell {
    
    var skill: Skill?
    
    static var height: CGFloat = 60

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameUnderline: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let skill = skill {
            setUp(skill: skill)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImageView.isHidden = !selected
        nameUnderline.isHidden = !selected
    }
    
    func setUp(skill: Skill) {
        self.skill = skill
        iconImageView.load(url: skill.imageUrl)
        nameLabel.text = skill.name
    }
}
