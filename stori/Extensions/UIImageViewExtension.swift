//
//  UIImageViewExtension.swift
//  stori
//
//  Created by Alex on 05.12.2020.
//

import UIKit
import Kingfisher

extension UIImageView {
    func load(url: URL?) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }
    
    func load(stringUrl: String) {
        load(url: URL(string: stringUrl))
    }
}
