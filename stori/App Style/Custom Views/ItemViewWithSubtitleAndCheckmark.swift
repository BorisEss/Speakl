//
//  ItemViewWithSubtitleAndCheckmark.swift
//  stori
//
//  Created by Alex on 25.01.2021.
//

import UIKit

class ItemViewWithSubtitleAndCheckmark: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet private weak var checkMarkImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    
    @IBInspectable var title: String? {
        didSet {
            updateTitle()
        }
    }
    @IBInspectable var subtitle: String? {
        get {
            return subtitleLabel.text
        }
        set(newValue) {
            subtitleLabel.isHidden = newValue == nil
            subtitleLabel.text = newValue
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var isChecked: Bool {
        get {
            return checkMarkImage.backgroundColor == .white
        }
        set(newValue) {
            checkMarkImage.backgroundColor = newValue ? .white : .accentColor
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var isEnabled: Bool {
        get {
            return actionButton.isEnabled
        }
        set(newValue) {
            actionButton.isEnabled = newValue
            contentView.alpha = newValue ? 1 : 0.5
        }
    }
    
    @IBInspectable var isOptional: Bool = false {
        didSet {
            updateTitle()
        }
    }
    
    var attributedTitle: NSAttributedString? {
        get {
            return titleLabel.attributedText
        }
        set(newValue) {
            titleLabel.attributedText = newValue
            layoutIfNeeded()
        }
    }
    
    var onClick: (() -> Void)?
    
    private var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setUp(title: String,
               subtitle: String,
               checked: Bool? = nil,
               enabled: Bool? = nil,
               isOptional: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        if let isChecked = checked {
            self.isChecked = isChecked
        }
        if let isEnabled = enabled {
            self.isEnabled = isEnabled
        }
        self.isOptional = isOptional
        updateTitle()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view?.frame = bounds
        view?.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view ?? UIView())
        self.view = view ?? UIView()
    }
    
    private func updateTitle() {
        if isOptional {
            let boldAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.IBMPlexSansBold(size: 15),
                .foregroundColor: UIColor.black
            ]
            let italicAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.IBMPlexSansLightItalic(size: 15),
                .foregroundColor: UIColor.black
            ]
            
            let finalString = NSMutableAttributedString(string: title ?? "",
                                                        attributes: boldAttributes)
            let secondString = NSAttributedString(string: " (\("common_optional".localized))",
                                                  attributes: italicAttributes)
            finalString.append(secondString)
            titleLabel.attributedText = finalString
        } else {
            titleLabel.text = title
        }
        layoutIfNeeded()
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        onClick?()
    }
}
