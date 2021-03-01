//
//  VocabularyHeaderTableViewCell.swift
//  stori
//
//  Created by Alex on 30.01.2021.
//

import UIKit

class VocabularyHeaderTableViewCell: UITableViewCell, CustomTableViewCell {

    static var height: CGFloat = 40
    
    private var title: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        guard let title = title else { return }
        setTitle(title: title)
    }
    
    func setTitle(title: String) {
        self.title = title
        titleLabel.text = title
    }
    
}
