//
//  HastagVideoCollectionViewCell.swift
//  stori
//
//  Created by Alex on 22.12.2021.
//

import UIKit

class HastagVideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    func setUp(video: Video) {
        thumbnailImageView.load(stringUrl: video.cover)
    }
}
