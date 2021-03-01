//
//  CSAddTableViewCell.swift
//  stori
//
//  Created by Alex on 31.01.2021.
//

import UIKit

class CSAddTableViewCell: UITableViewCell, CustomTableViewCell {
    
    static var height: CGFloat = 111
    
    var createTextHandler: (() -> Void)?
    var createMediaHandler: ((LocalFile) -> Void)?

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var addSection: UIView!
    @IBOutlet weak var addLabel: UILabel!
    
    @IBOutlet weak var addTextSection: UIView!
    @IBOutlet weak var addTextLabel: UILabel!
    
    @IBOutlet weak var addImageSection: UIView!
    @IBOutlet weak var addImageLabel: UILabel!
    
    @IBOutlet weak var addVideoSection: UIView!
    @IBOutlet weak var addVideoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLangauge()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        showItems()
    }
    
    @IBAction func addTextPressed(_ sender: Any) {
        createTextHandler?()
        showAddButton()
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        ImagePicker.pickImage(from: .library, frontCamera: false) { (image) in
            self.createMediaHandler?(image)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAddButton()
        }
    }
    
    @IBAction func addVideoPressed(_ sender: Any) {
        ImagePicker.pickVideo(from: .library) { (video) in
            self.createMediaHandler?(video)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAddButton()
        }
    }
    
    private func setUpLangauge() {
        addLabel.text = "cs_text_add".localized
        addTextLabel.text = "cs_text_add_text".localized
        addImageLabel.text = "cs_text_add_image".localized
        addVideoLabel.text = "cs_text_add_video".localized
    }

    func showItems() {
        UIView.transition(from: addSection,
                          to: stackView,
                          duration: 0.4,
                          options: [.transitionFlipFromTop,
                                    .layoutSubviews,
                                    .showHideTransitionViews],
                          completion: nil)
    }
    
    func showAddButton() {
        UIView.transition(from: stackView,
                          to: addSection,
                          duration: 0.4,
                          options: [.transitionFlipFromBottom,
                                    .layoutSubviews,
                                    .showHideTransitionViews],
                          completion: nil)
    }
}
