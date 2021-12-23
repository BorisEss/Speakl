//
//  AppActivityIndicator.swift
//  flyswap
//
//  Created by Alex on 7/27/20.
//  Copyright © 2020 IDEACTION. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AppActivityIndicator: UIView {

    let contentXibName = "AppActivityIndicator"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView! {
        didSet {
            activityIndicatorView.type = .ballPulse
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)
        contentView.fixInView(self)
        activityIndicatorView.color = tintColor
        layoutIfNeeded()
    }
    
    func startAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
        }
    }
}
