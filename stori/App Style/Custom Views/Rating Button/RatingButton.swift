//
//  RatingButton.swift
//  stori
//
//  Created by Alex on 28.04.2021.
//

import UIKit

class RatingButton: UIButton {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var imageCircleView: UIView!
    @IBOutlet weak var buttonImageView: UIImageView!
    
    @IBInspectable var buttonImage: UIImage? {
        didSet {
            customInit()
        }
    }

    var isChecked: Bool = false {
        didSet {
            imageCircleView.borderWidth = isChecked ? 4 : 0
        }
    }

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
        Bundle.main.loadNibNamed("RatingButton", owner: self, options: nil)

        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.buttonImageView.image = buttonImage
        self.imageCircleView.borderWidth = isChecked ? 4 : 0
    }
}
