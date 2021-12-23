//
//  UnderlinedButton.swift
//  stori
//
//  Created by Alex on 14.12.2021.
//

import UIKit

class UnderlinedButton: UIButton {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    
    @IBInspectable var localizedButtonTitle: String? {
        didSet {
            customInit()
        }
    }
    
    @IBInspectable var isChecked: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.buttonLabel.textColor = self.isChecked ? .gradientBotton : .brightGray
                self.underlineView.backgroundColor = self.isChecked ? .gradientBotton : .greyLight
                self.layoutIfNeeded()
            } completion: { _ in
                if self.isChecked {
                    Vibration().light()
                }
            }
        }
    }
    
    //  init used if the view is created programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    //  init used if the view is created through IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    //  Do custom initialization here
    private func customInit() {
        Bundle.main.loadNibNamed("UnderlinedButton", owner: self, options: nil)

        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        buttonLabel.text = localizedButtonTitle // TODO: Made it localized
        buttonLabel.textColor = isChecked ? .gradientBotton : .brightGray
        underlineView.backgroundColor = isChecked ? .gradientBotton : .greyLight
    }

}
