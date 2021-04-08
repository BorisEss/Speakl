//
//  CSItemTableViewCell.swift
//  stori
//
//  Created by Alex on 25.01.2021.
//

import UIKit

class CSItemTableViewCell: UITableViewCell, CustomTableViewCell {
    
    enum CSItemType {
        case title
        case titleAndImage
        case language
        case languageLevel
    }
    
    static var height: CGFloat = 96
    
    var type: CSItemType?
    var titleText: String?
    var icon: String?
    var language: Language?
    var languageLevel: LanguageLevel?

    @IBOutlet weak var leftIconView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var levelShortculLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let type = type {
            switch type {
            case .title:
                guard let titleText = titleText else { return }
                setTitle(titleText)
            case .titleAndImage:
                guard let titleText = titleText else { return }
                guard let icon = icon else { return }
                setTitleAndImage(title: titleText, image: icon)
            case .language:
                guard let language = language else { return }
                setLanguage(language: language)
            case .languageLevel:
                guard let languageLevel = languageLevel else { return }
                setLanguageLevel(level: languageLevel)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkMarkImageView.isHidden = !selected
    }
    
    func setTitle(_ title: String) {
        type = .title
        titleText = title
        leftIconView.isHidden = true
        titleLabel.text = title
    }
    
    func setTitleAndImage(title: String, image: String) {
        type = .titleAndImage
        titleText = title
        icon = image
        leftIconView.cornerRadius = 0
        leftIconView.borderWidth = 0
        leftIconView.backgroundColor = .clear
        iconImageView.load(stringUrl: image)
        titleLabel.text = title
    }
    
    func setLanguage(language: Language) {
        type = .language
        self.language = language
        setLanguageIcon(url: language.flagUrl)
        titleLabel.text = language.name
    }
    
    func setLanguageLevel(level: LanguageLevel) {
        type = .languageLevel
        self.languageLevel = level
        setLanguageLevelIncon(level: level)
        titleLabel.text = level.name
    }
    
    private func setLanguageIcon(url: URL?) {
        leftIconView.cornerRadius = 20
        leftIconView.borderWidth = 2
        iconImageView.load(url: url)
    }
    
    private func setLanguageLevelIncon(level: LanguageLevel) {
        levelShortculLabel.isHidden = false
        levelShortculLabel.attributedText = level.attributedShortcut
        iconImageView.isHidden = true
        leftIconView.cornerRadius = 20
        leftIconView.borderWidth = 2
        leftIconView.backgroundColor = level.color
    }
}
