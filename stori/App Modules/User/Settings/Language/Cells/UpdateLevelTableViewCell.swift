//
//  UpdateLevelTableViewCell.swift
//  stori
//
//  Created by Alex on 30.04.2021.
//

import UIKit
import MBCircularProgressBar

class UpdateLevelTableViewCell: UITableViewCell, CustomTableViewCell {

    static var height: CGFloat = 96

    private var level: LanguageLevel?
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var checkmarkBadgeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let level = level {
            setLanguageLevel(level: level)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cellView.borderWidth = selected ? 2 : 0
        checkmarkBadgeView.isHidden = !selected
    }
    
    func setLanguageLevel(level: LanguageLevel) {
        let progress: Int = (0...100).randomElement() ?? 0
        let words: Int = (0...1000).randomElement() ?? 0
        titleLabel.text = "\(level.shortcut ?? "") - \(level.name)"
        descriptionLabel.text = String(format: "edit_learning_level_progress".localized,
                                       progress,
                                       words)
        progressView.value = CGFloat(progress)
    }
}
