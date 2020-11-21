//
//  CustomCollectionViewCell.swift
//  stori
//
//  Created by Alex on 21.11.2020.
//

import UIKit

protocol CustomCollectionViewCell: UICollectionViewCell {
    static var xibName: String { get }
    static var identifier: String { get }
}

extension CustomCollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: xibName, bundle: nil)
    }
}
