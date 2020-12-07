//
//  LanguageTableViewCell.swift
//  stori
//
//  Created by Alex on 01.12.2020.
//

import UIKit

class LanguageTableViewCell: UITableViewCell, CustomTableViewCell {
    
    static var xibName: String = "LanguageTableViewCell"
    static var identifier: String = "LanguageTableViewCell"
    static var height: CGFloat = 60
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            checkMarkImageView.isHidden = !isSelected
        }
    }
    
    func setUp(language: Language) {
        flagImageView.load(url: language.flagUrl)
        languageNameLabel.text = language.name
    }
}
