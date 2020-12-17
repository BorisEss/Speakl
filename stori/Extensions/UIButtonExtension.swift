//
//  UIButtonExtension.swift
//  stori
//
//  Created by Alex on 17.12.2020.
//

import Foundation
import SDWebImage

extension UIButton {
    func load(url: URL?) {
        let transformer = SDImageResizingTransformer(size: frame.size.applying(CGAffineTransform(scaleX: 1.5,
                                                                                                 y: 1.5)),
                                                     scaleMode: .aspectFill)
        
        let indicator = SDWebImageActivityIndicator.gray
        indicator.indicatorView.color = tintColor
        sd_imageIndicator = indicator
        sd_setImage(with: url,
                    for: .normal,
                    placeholderImage: nil,
                    context: [.imageTransformer: transformer])
    }
    
    func load(stringUrl: String) {
        load(url: URL(string: stringUrl))
    }
}
