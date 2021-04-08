//
//  CSStoryTitleViewController.swift
//  stori
//
//  Created by Alex on 25.01.2021.
//

import UIKit
import TableFlip

class CSStoryTitleViewController: UIViewController {
    
    private let continueToStoryCreationSegue = "continueToStoryCreation"

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var storyNameTitleLabel: UILabel!
    @IBOutlet weak var storyNameTextField: UITextField!
    @IBOutlet weak var nextButton: RegularButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        checkTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent,
           CreateStoryObject.shared != nil {
            CreateStoryObject.shared = nil
            Toast.success("cs_story_saved_to_drafts".localized)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = storyNameTextField.text ?? ""
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let name = storyNameTextField.text else { return }
        nextButton.isHidden = true
        progressActivityIndicator.startAnimating()
        
        if CreateStoryObject.shared == nil {
            CSPresenter.story.createStory(name: name)
                .done { (response) in
                    CreateStoryObject.shared = CreateStoryObject(model: response)
                    self.performSegue(withIdentifier: self.continueToStoryCreationSegue, sender: nil)
                }
                .ensure {
                    self.nextButton.isHidden = false
                    self.progressActivityIndicator.stopAnimating()
                }
                .cauterize()
        } else {
            guard let id = CreateStoryObject.shared?.id else {
                nextButton.isHidden = false
                progressActivityIndicator.stopAnimating()
                return
            }
            CSPresenter.story.updateStory(id: id, name: name)
                .done { (response) in
                    CreateStoryObject.shared?.name = response.name
                    self.performSegue(withIdentifier: self.continueToStoryCreationSegue, sender: nil)
                }
                .ensure {
                    self.nextButton.isHidden = false
                    self.progressActivityIndicator.stopAnimating()
                }
                .cauterize()
        }
    }
    
    private func setUpLanguage() {
        title = "cs_story_title_navbar_title".localized
        descriptionLabel.text = "cs_story_title_description".localized
        storyNameTitleLabel.text = "cs_story_title_story_name_label".localized
        storyNameTextField.placeholder = "cs_story_title_story_name_placeholder".localized
        nextButton.setTitle("common_next_title".localized, for: .normal)
        nextButton.setTitle("common_next_title".localized, for: .disabled)
    }
    
    private func checkTitle() {
        if let storyName = storyNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           storyName.count > 3,
           !storyName.isValidEmail {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}

extension CSStoryTitleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkTitle()
    }
}
