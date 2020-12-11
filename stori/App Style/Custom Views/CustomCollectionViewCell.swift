//
//  CustomCollectionViewCell.swift
//  stori
//
//  Created by Alex on 21.11.2020.
//

import UIKit

protocol CustomCollectionViewCell: UICollectionViewCell { }

extension CustomCollectionViewCell {
    
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
