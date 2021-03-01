//
//  CSCustomItemViewController.swift
//  stori
//
//  Created by Alex on 26.01.2021.
//

import UIKit
import PromiseKit

class CSCustomItemViewController: UIViewController {

    var listType: CSListType?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var saveButton: RegularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? CSCustomItemPopUpViewController {
            nextVc.listType = listType
            nextVc.completion = {
                self.navigationController?.popViewController(animated: true)
//                for controller in self.navigationController!.viewControllers as Array {
//                    if controller.isKind(of: CSMainListViewController.self) {
//                        _ =  self.navigationController!.popToViewController(controller, animated: true)
//                        break
//                    }
//                }
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let text = nameTextField.text else { return }
        guard let listType = listType else { return }
        switch listType {
        case .topic:
            guard let language = CreateStoryObject.shared?.language else { return }
            CSPresenter.topic.createTopic(for: language, name: text)
                .done { (_) in
                    self.showInformationalPopUp()
                }
                .cauterize()
        case .category:
            guard let category = CreateStoryObject.shared?.topic else { return }
            CSPresenter.category.createCategory(topicId: category.id, name: text)
                .done { (_) in
                    self.showInformationalPopUp()
                }
                .cauterize()
        case .subCategory:
            guard let category = CreateStoryObject.shared?.category else { return }
            CSPresenter.subCategory.createSubCategory(categoryId: category.id, name: text)
                .done { (_) in
                    self.showInformationalPopUp()
                }
                .cauterize()
        case .language:
            CSPresenter.langauge.createLanguage(language: text)
                .done { (_) in
                    self.showInformationalPopUp()
                }
                .cauterize()
        case .languageLevel:
            CSPresenter.languageLevel.createLanguageLevel(levelName: text)
                .done { (_) in
                    self.showInformationalPopUp()
                }
                .cauterize()
        }
    }
    
    private func showInformationalPopUp() {
        performSegue(withIdentifier: "showAlert", sender: nil)
    }
    
    private func setUpLanguage() {
        saveButton.setTitle("common_save".localized, for: .normal)
        saveButton.setTitle("common_save".localized, for: .disabled)
        guard let listType = listType else { return }
        switch listType {
        case .topic:
            nameTextField.placeholder = "cs_custom_item_topic_placeholder".localized
        case .category:
            nameTextField.placeholder = "cs_custom_item_category_placeholder".localized
        case .subCategory:
            nameTextField.placeholder = "cs_custom_item_sub_category_placeholder".localized
        case .language:
            nameTextField.placeholder = "cs_custom_item_language_placeholder".localized
        case .languageLevel:
            nameTextField.placeholder = "cs_custom_item_language_level_placeholder".localized
        }
    }

}

extension CSCustomItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkMarkImage.isHidden = true
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            checkMarkImage.isHidden = true
            saveButton.isEnabled = false
            return
        }
        checkMarkImage.isHidden = text.count <= 3
        saveButton.isEnabled = text.count > 3
    }
}
