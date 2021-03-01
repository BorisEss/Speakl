///
//  CSImageItemTableViewCell.swift
//  stori
//
//  Created by Alex on 01.02.2021.
//

import UIKit

class CSImageItemTableViewCell: CSTableViewCell {
    
    var sectionFile: StoryImageSection?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let section = sectionFile {
            setUp(section: section)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editActionCallback?()
    }
    
    func setUp(section: StoryImageSection) {
        let cellWidth = UIScreen.main.bounds.width - 40
        self.sectionFile = section
        if let image = section.file.image {
            let ratio = cellWidth / image.size.width
            self.imageHeight.constant = image.size.height * ratio
        }
        self.itemImageView.image = section.file.image
        if !section.finishedUpload {
            startUploading()
            section.didFinishUpload = {
                self.stopUploading()
            }
        } else {
            stopUploading()
        }
    }
    
    func startUploading() {
        progressActivityIndicator.startAnimating()
        editButton.isEnabled = false
        itemImageView.alpha = 0.7
    }
    
    func stopUploading() {
        progressActivityIndicator.stopAnimating()
        editButton.isEnabled = true
        itemImageView.alpha = 1
    }
}
