//
//  SearchHeaderTableViewCell.swift
//  stori
//
//  Created by Alex on 14.12.2021.
//

import UIKit

class SearchHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
}
