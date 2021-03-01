//
//  LanguageLevelTableViewCell.swift
//  stori
//
//  Created by Alex on 10.12.2020.
//

import UIKit

class LanguageLevelTableViewCell: UITableViewCell, CustomTableViewCell {

    private var level: LanguageLevel?
    
    static var height: CGFloat = 60
    
    @IBOutlet weak var levelIconView: UIView!
    @IBOutlet weak var levelShortcutLabel: UILabel!
    @IBOutlet weak var levelTitleLabel: UILabel!
    @IBOutlet weak var levelTitleUnderlineView: UIView!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let level = level {
            setUp(level: level)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkMarkImageView.isHidden = !isSelected
        levelTitleUnderlineView.isHidden = !isSelected
    }
    
    func setUp(level: LanguageLevel) {
        self.level = level
        levelIconView.backgroundColor = level.color
        levelShortcutLabel.attributedText = level.attributedShortcut
        levelTitleLabel.text = level.name
    }
}
