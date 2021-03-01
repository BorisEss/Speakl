//
//  FileTableViewCell.swift
//  stori
//
//  Created by Alex on 06.01.2021.
//

import UIKit

class FileTableViewCell: UITableViewCell, CustomTableViewCell {

    var removeHadler: (() -> Void)?
    var shouldRemove: Bool = true
    
    private var file: LocalFile?
    
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let file = file {
            updateView(file: file)
        }
    }
    
    func setUp(file: LocalFile) {
        self.file = file
        updateView(file: file)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        if shouldRemove {
            guard let file = file else { return }
            Upload.remove(file: file) { [weak self] (isSuccess) in
                if isSuccess { self?.removeHadler?() }
            }
        } else {
            self.removeHadler?()
        }
    }
    
    private func updateView(file: LocalFile) {
        fileNameLabel.text = file.name
        fileImage.image = file.image
        animateProgressBar(value: file.uploadProgress)
        file.uploadHandler = { [weak self] progress in
            self?.animateProgressBar(value: progress)
        }
    }
    
    private func animateProgressBar(value: Double?) {
        guard let value = value else { return }
        progressBar.setProgress(Float(value), animated: true)
        removeButton.isHidden = value != 1
    }
}
