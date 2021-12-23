//
//  UICollectionViewExtension.swift
//  stori
//
//  Created by Alex on 09.12.2021.
//

import UIKit

public extension UICollectionView {
    func centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout,
            layout.scrollDirection == .horizontal else {
                assertionFailure("\(#function): layout.scrollDirection != .horizontal")
                return
        }

        if layout.collectionViewContentSize.width > frame.size.width {
            contentInset = minimumInset
        } else {
            contentInset = UIEdgeInsets(top: minimumInset.top,
                                        left: (frame.size.width - layout.collectionViewContentSize.width) / 2,
                                        bottom: minimumInset.bottom,
                                        right: 0)
        }
    }
}
