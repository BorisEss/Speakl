//
//  TeacherUserReviewView.swift
//  stori
//
//  Created by Alex on 26.06.2022.
//

import UIKit

class TeacherUserReviewView: UIView {
    
    var handleTap: (() -> Void)?

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userStarsLabel: UILabel!
    @IBOutlet weak var userReviewLabel: UILabel!
    @IBOutlet weak var userReviewTimeLabel: UILabel!
    
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
        Bundle.main.loadNibNamed("TeacherUserReviewView", owner: self, options: nil)
        
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        userImageView.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        userNameLabel.addGestureRecognizer(tap2)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        handleTap?()
    }
}
