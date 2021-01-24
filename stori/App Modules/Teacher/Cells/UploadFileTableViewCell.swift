//
//  UploadFileTableViewCell.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit

class UploadFileTableViewCell: UITableViewCell, CustomTableViewCell {
    
    static var height: CGFloat = 95
    var completion: ((_ file: LocalFile) -> Void)?
    var frontCamera: Bool = false
    
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var takePictureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        
        setUpLanguage()
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        ImagePicker.pickImage(from: .library) { file in
            self.completion?(file)
        }
    }
    @IBAction func takePicturePressed(_ sender: Any) {
        ImagePicker.pickImage(from: .camera, frontCamera: frontCamera) { file in
            self.completion?(file)
        }
    }
    
    func setUpLanguage() {
        uploadLabel.text = "common_upload".localized
        takePictureLabel.text = "common_take_picture".localized
    }
}
