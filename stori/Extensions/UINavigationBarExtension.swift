//
//  UINavigationBarExtension.swift
//  stori
//
//  Created by Alex on 29.12.2020.
//

import UIKit

extension UINavigationBar {
    func addShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 8)
        removeUnderline()
    }
    func removeUnderline() {
        shadowImage = UIImage()
        layoutIfNeeded()
    }
    func setUpFont() {
        titleTextAttributes = [NSAttributedString.Key.font: UIFont.IBMPlexSansBold(size: 16)]
    }
}

extension UINavigationItem {
    func setTitleAndSubtitle(title: String, subtitle: String) {
        let titleLabel = UILabel(frame: CGRect(x: 0,
                                               y: -5,
                                               width: 0,
                                               height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.textBlack
        titleLabel.font = UIFont.IBMPlexSansBold(size: 16)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0,
                                                  y: 18,
                                                  width: 0,
                                                  height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.textGray
        subtitleLabel.font = UIFont.IBMPlexSans(size: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStackView.axis = .vertical
        titleStackView.alignment = .center
        
        self.titleView = titleStackView
    }
}
