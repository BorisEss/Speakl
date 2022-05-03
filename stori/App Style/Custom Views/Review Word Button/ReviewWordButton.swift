//
//  ReviewWordButton.swift
//  stori
//
//  Created by Alex on 02.05.2022.
//

import UIKit

private enum ReviewWordButtonStatus {
    case empty
    case selected
    case correct
    case wrong
}

class ReviewWordButton: UIButton {
    
    private var buttonStatus: ReviewWordButtonStatus = .empty {
        didSet {
            switch buttonStatus {
            case .empty:
                contentView.borderWidth = 0
                contentView.borderColor = .clear
                iconView.borderWidth = 3
                iconView.backgroundColor = .clear
                iconImageView.image = nil
                wordLabel.textColor = UIColor(named: "Text Black")
            case .selected:
                contentView.borderWidth = 3
                contentView.borderColor = UIColor(named: "Text Gray")
                iconView.borderWidth = 0
                iconView.backgroundColor = UIColor(named: "Text Gray")
                iconImageView.image = nil
                wordLabel.textColor = UIColor(named: "Text Black")
            case .correct:
                contentView.borderWidth = 3
                contentView.borderColor = UIColor(named: "AccentColor")
                iconView.borderWidth = 0
                iconView.backgroundColor = UIColor(named: "AccentColor")
                iconImageView.image = UIImage(named: "check_mark_clear")
                wordLabel.textColor = UIColor(named: "AccentColor")
            case .wrong:
                contentView.borderWidth = 3
                contentView.borderColor = UIColor(named: "Text Gray")
                iconView.borderWidth = 0
                iconView.backgroundColor = UIColor(named: "Text Gray")
                iconImageView.image = UIImage(named: "cross_icon_clear")
                wordLabel.textColor = UIColor(named: "Text Black")
            }
        }
    }

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!

    //  init used if the view is created programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }

    //  init used if the view is created through IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }

    //  Do custom initialization here
    private func customInit() {
        Bundle.main.loadNibNamed("ReviewWordButton", owner: self, options: nil)

        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.buttonStatus = .empty
    }
    
    func setWord(word: String) {
        buttonStatus = .empty
        wordLabel.text = word
    }
    
    func setSelected() {
        buttonStatus = .selected
    }

    func setCorrect() {
        buttonStatus = .correct
    }
    
    func setWrong() {
        buttonStatus = .wrong
    }
    
    func clear() {
        buttonStatus = .empty
    }
    
    func isSelected() -> Bool {
        return buttonStatus == .selected
    }
}
