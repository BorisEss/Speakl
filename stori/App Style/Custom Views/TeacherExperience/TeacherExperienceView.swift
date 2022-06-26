//
//  TeacherExperienceView.swift
//  stori
//
//  Created by Alex on 26.06.2022.
//

import UIKit

class TeacherExperienceView: UIView {

    @IBOutlet weak var contentView: UIView!
    
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
        Bundle.main.loadNibNamed("TeacherExperienceView", owner: self, options: nil)
        
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}
