//
//  CustomTableViewCell.swift
//  stori
//
//  Created by Alex on 01.12.2020.
//

import UIKit

enum CellState {
    case disabled
    case selected
    case normal
}

protocol CustomTableViewCell: UITableViewCell { }

extension CustomTableViewCell {
    
    static var xibName: String {
        return String(describing: self)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: xibName, bundle: nil)
    }
}
