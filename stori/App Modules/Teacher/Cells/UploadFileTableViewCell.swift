//
//  UploadFileTableViewCell.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit

class UploadFileTableViewCell: UITableViewCell, CustomTableViewCell {
    
    static var height: CGFloat = 95
    var completion: ((_ file: UploadedFile) -> Void)?
    
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
        ImagePicker.pickImage(from: .camera) { file in
            self.completion?(file)
        }
    }
    
    func setUpLanguage() {
        // TODO: Finish language
        uploadLabel.text = "Upload"
        takePictureLabel.text = "Take a picture"
    }
}
