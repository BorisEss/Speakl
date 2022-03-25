//
//  AppActivityIndicator.swift
//  flyswap
//
//  Created by Alex on 7/27/20.
//  Copyright © 2020 IDEACTION. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

/// This is Activity Indicator view which is made customly for the `Speakl` application.
///
/// To use this Activity Indicator just add a `UIView` to the Storyboard and set it's class to `AppActivityIndicator`.
/// After that in code you can use the specific methods to start/stop animation:
///
/// - `startAnimating()`
/// - `stopAnimating()`
///
/// Also if you need to check if the activity indicator is animating you can access the `isAnimating` value.
///
class AppActivityIndicator: UIView {

    private let contentXibName = "AppActivityIndicator"
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var activityIndicatorView: NVActivityIndicatorView! {
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
    
    private func commonInit() {
        Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)
        contentView.fixInView(self)
        activityIndicatorView.color = tintColor
        layoutIfNeeded()
    }
    
    /// Activity Indicator starts animating.
    func startAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    /// Activity Indicator stops animating.
    func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
        }
    }
    
    /// Checks if the current activity indicator is animating.
    /// - Returns: `Bool` value which determines if the activity indicator is animating or not
    var isAnimating: Bool {
        return activityIndicatorView.isAnimating
    }
}
