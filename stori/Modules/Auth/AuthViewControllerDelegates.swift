//
//  AuthViewControllerDelegates.swift
//  stori
//
//  Created by Alex on 25.11.2020.
//

import UIKit

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch authType {
        case .login:
            loginFieldDelegate(textField)
        case .signup:
            signUpFieldDelegate(textField)
        case .forgotPassword:
            forgotPasswordFieldDelegate(textField)
        case .resetPassword:
            resetPasswordFieldDelegate(textField)
        }
        return true
    }
    
    private func loginFieldDelegate(_ textField: UITextField) {
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            logIn()
        }
    }
    
    private func signUpFieldDelegate(_ textField: UITextField) {
        switch textField {
        case usernameTextField: emailTextField.becomeFirstResponder()
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: repeatPasswordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            signUp()
        }
    }
    
    private func forgotPasswordFieldDelegate(_ textField: UITextField) {
        textField.resignFirstResponder()
        forgotPassword()
    }
    
    private func resetPasswordFieldDelegate(_ textField: UITextField) {
        switch textField {
        case codeTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: repeatPasswordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            resetPassword()
        }
    }
}

// MARK: - KeyboardApperenceHandlerDelegate
extension AuthViewController: KeyboardApperenceHandlerDelegate {
    func keyboardWillAppear(keyboardHeight: CGFloat) {
        bottomStackViewConstraint.constant = keyboardHeight
        bottomImageConstraint.constant = keyboardHeight / 2
        switch authType {
        case .login:
            titleLabel.isHidden = true
            socialView.isHidden = true
        case .signup:
            logoSection.isHidden = true
            titleLabel.isHidden = true
        case .forgotPassword:
            break
        case .resetPassword:
            logoSection.isHidden = true
        }
    }
    
    func keyboardWillDisapear() {
        bottomStackViewConstraint.constant = 28
        bottomImageConstraint.constant = 19
        switch authType {
        case .login:
            titleLabel.isHidden = false
            socialView.isHidden = false
        case .signup:
            logoSection.isHidden = false
            titleLabel.isHidden = false
        case .forgotPassword:
            break
        case .resetPassword:
            logoSection.isHidden = false
        }
    }
}
