//
//  CSCustomItemPopUpViewController.swift
//  stori
//
//  Created by Alex on 16.02.2021.
//

import UIKit

class CSCustomItemPopUpViewController: UIViewController {

    var descriptionText: String?
    var listType: CSListType?
    var completion: (() -> Void)?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var okButton: RegularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        completion?()
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpLanguage() {
        if let listType = listType {
            switch listType {
            case .topic:
                descriptionLabel.text = "cs_custom_item_topic_popup".localized
            case .category:
                descriptionLabel.text = "cs_custom_item_category_popup".localized
            case .subCategory:
                descriptionLabel.text = "cs_custom_item_sub_category_popup".localized
            case .language:
                descriptionLabel.text = "cs_custom_item_language_popup".localized
            case .languageLevel:
                descriptionLabel.text = "cs_custom_item_language_level_popup".localized
            }
        } else {
            descriptionLabel.text = descriptionText
        }
        okButton.setTitle("common_ok".localized, for: .normal)
    }
}
