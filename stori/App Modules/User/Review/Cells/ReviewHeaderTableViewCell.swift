//
//  ReviewHeaderTableViewCell.swift
//  stori
//
//  Created by Alex on 28.04.2022.
//

import UIKit

protocol ReviewHeaderTableViewCellDelegate: AnyObject {
    func clearButtonWasPressed()
}

class ReviewHeaderTableViewCell: UITableViewCell, CustomTableViewCell {
    
    weak var delegate: ReviewHeaderTableViewCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearStackView: UIStackView!
    @IBOutlet weak var clearTitleButton: UIButton!
    
    func setUp(name: String, shouldShowClose: Bool = false) {
        titleLabel.text = name
        clearStackView.isHidden = !shouldShowClose
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        delegate?.clearButtonWasPressed()
    }
    
}
