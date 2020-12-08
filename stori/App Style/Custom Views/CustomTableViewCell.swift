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

protocol CustomTableViewCell: UITableViewCell {
    static var xibName: String { get }
    static var identifier: String { get }
}

extension CustomTableViewCell {
    static func nib() -> UINib {
        return UINib(nibName: xibName, bundle: nil)
    }
}
