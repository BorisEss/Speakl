//
//  FileTableViewCell.swift
//  stori
//
//  Created by Alex on 06.01.2021.
//

import UIKit

class FileTableViewCell: UITableViewCell, CustomTableViewCell {

    private var file: UploadedFile?
    
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    
    func setUp(file: UploadedFile) {
        self.file = file
        updateView()
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        
    }
    
    private func updateView() {
        if let file = file {
            if file.id.isEmpty {
                progressBar.progress = 0.2
            } else {
                progressBar.progress = 1
            }
            fileNameLabel.text = file.name
            fileImage.image = file.image
        }
    }
}
