//
//  ChangePasswordViewController.swift
//  stori
//
//  Created by Alex on 26.04.2021.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: RegularButton!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if let oldPassword = oldPasswordTextField.text,
           let newPassword = newPasswordTextField.text,
           let confirmPassword = confirmPasswordTextField.text,
           oldPassword.isValidPassword,
           newPassword.isValidPassword,
           confirmPassword.isValidPassword,
           newPassword == confirmPassword {
            dismissKeyboard()
            progressActivityIndicator.startAnimating()
            oldPasswordTextField.isEnabled = false
            newPasswordTextField.isEnabled = false
            confirmPasswordTextField.isEnabled = false
            saveButton.isHidden = true
            UserClient.changePassword(oldPassword: oldPassword,
                                      newPassword: newPassword)
                .ensure {
                    self.progressActivityIndicator.stopAnimating()
                    self.oldPasswordTextField.isEnabled = true
                    self.newPasswordTextField.isEnabled = true
                    self.confirmPasswordTextField.isEnabled = true
                    self.saveButton.isHidden = false
                }
                .done { (_) in
                    Toast.success("edit_password_success".localized)
                    self.navigationController?.popViewController(animated: true)
                }
                .catch { (error) in
                    error.parse()
                }
        }
    }
    
    private func setUpLanguage() {
        title = "edit_password_title".localized
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
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
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
    
    private func checkFields() {
        if !(oldPasswordTextField.text?.isValidPassword ?? false) {
            saveButton.isEnabled = false
            return
        }
        if !(newPasswordTextField.text?.isValidPassword ?? false) {
            saveButton.isEnabled = false
            return
        }
        if !(confirmPasswordTextField.text?.isValidPassword ?? false) {
            saveButton.isEnabled = false
            return
        }
        if let newPassword = newPasswordTextField.text,
           let confirmPassword = confirmPasswordTextField.text,
           newPassword != confirmPassword {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkFields()
    }
}
