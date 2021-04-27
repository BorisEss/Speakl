//
//  EditUsernameViewController.swift
//  stori
//
//  Created by Alex on 26.04.2021.
//

import UIKit

class EditUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var saveButton: RegularButton!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        loadData()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if let username = usernameTextField.text {
            progressActivityIndicator.startAnimating()
            usernameTextField.isEnabled = false
            saveButton.isHidden = true
            UserClient.updateUsername(username: username)
                .ensure {
                    self.progressActivityIndicator.stopAnimating()
                    self.usernameTextField.isEnabled = true
                    self.saveButton.isHidden = false
                }
                .done { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
                .catch { (error) in
                    error.parse()
                }
        }
    }
    
    private func setUpLanguage() {
        title = "edit_personal_info_change_username".localized
    }
    
    private func loadData() {
        usernameTextField.text = Storage.shared.currentUser?.username
    }
    
    private func checkChanges() {
        if let newUsername = usernameTextField.text,
           let oldUsername = Storage.shared.currentUser?.username {
            if newUsername.isEmpty {
                saveButton.isEnabled = false
                return
            }
            if newUsername.count < 3 {
                saveButton.isEnabled = false
                return
            }
            if newUsername == oldUsername {
                saveButton.isEnabled = false
                return
            }
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    private func setUpUI() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let window = UIApplication.shared.windows[0]
            let bottomPadding = window.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.7) {
                self.bottomButtonConstraint.constant = keyboardHeight + 20 - bottomPadding
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.7) {
            self.bottomButtonConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
    }
}

extension EditUsernameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkChanges()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
