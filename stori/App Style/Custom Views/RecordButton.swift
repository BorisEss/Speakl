//
//  RecordButton.swift
//  stori
//
//  Created by Alex on 29.01.2021.
//

import UIKit

class RecordButton: UIButton {
    
    var onClick: (() -> Void)?
    
    @IBInspectable var strokeWidth: CGFloat {
        get {
            return contentView.borderWidth
        }
        set(newValue) {
            contentView.borderWidth = newValue
            topSpacingConstraint.constant = newValue
        }
    }
    @IBInspectable var strokeColor: UIColor? {
        get {
            return contentView.borderColor
        }
        set(newValue) {
            contentView.borderColor = newValue
        }
    }
    
    @IBInspectable var insideColor: UIColor? {
        get {
            return insideView.backgroundColor
        }
        set(newValue) {
            insideView.backgroundColor = newValue
        }
    }
    
    var isRecording: Bool = false {
        didSet {
            if isRecording {
                showRecordingStyle()
            } else {
                showPasiveStyle()
            }
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var topSpacingConstraint: NSLayoutConstraint!
    
    private var view: UIView!
    
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
        
        contentView.cornerRadius = bounds.height / 2
        insideView.cornerRadius = insideView.bounds.height / 2
    }
    
    private func showRecordingStyle() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.topSpacingConstraint.constant = self.bounds.height / 4
            self.insideView.layer.cornerRadius = 5
            self.layoutIfNeeded()
        }
    }
    
    private func showPasiveStyle() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.topSpacingConstraint.constant = self.strokeWidth
            self.insideView.layer.cornerRadius = (self.bounds.height - self.strokeWidth * 2) / 2
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func clickAction(_ sender: Any) {
        isRecording = !isRecording
        onClick?()
    }
}
