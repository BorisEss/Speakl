//
//  LanguageTableViewCell.swift
//  stori
//
//  Created by Alex on 01.12.2020.
//

import UIKit

class LanguageTableViewCell: UITableViewCell, CustomTableViewCell {
    
    var language: Language?
    var state: CellState = .normal {
        didSet {
            switch state {
            case .disabled:
                contentView.alpha = 0.2
                nameUnderline.isHidden = false
                checkMarkImageView.isHidden = false
            case .selected:
                contentView.alpha = 1
                nameUnderline.isHidden = false
                checkMarkImageView.isHidden = false
            case .normal:
                contentView.alpha = 1
                nameUnderline.isHidden = true
                checkMarkImageView.isHidden = true
            }
        }
    }
    
    static var height: CGFloat = 60
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var nameUnderline: UIView!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let language = language {
            setUp(language: language)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if state != .disabled {
            state = isSelected ? .selected : .normal
        }
    }
    
    func setUp(language: Language) {
        self.language = language
        flagImageView.load(url: language.flagUrl)
        languageNameLabel.text = language.name
    }
    
    func disable() {
        state = .disabled
    }
    
    func enable() {
        state = .normal
    }
}
