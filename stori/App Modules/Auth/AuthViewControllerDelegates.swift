//
//  AuthViewControllerDelegates.swift
//  stori
//
//  Created by Alex on 25.11.2020.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

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
            agreementLabel.isHidden = true
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
            agreementLabel.isHidden = false
        case .forgotPassword:
            break
        case .resetPassword:
            logoSection.isHidden = false
        }
    }
}

// MARK: ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension AuthViewController: ASAuthorizationControllerDelegate {
    // Authorization Failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #if DEBUG
        print(error.localizedDescription)
        #endif
        appleButton.isHidden = false
        appleActivityIndicator.stopAnimating()
    }

    // Authorization Succeeded
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let data = credential.authorizationCode, let code = String(data: data, encoding: .utf8) {
                // Now send the 'code' to your backend to get an API token.
                #if DEBUG
                print("Code: \(code)")
                print("User ID: \(credential.user)")
                print("User First Name: \(credential.fullName?.givenName ?? "")")
                print("User Last Name: \(credential.fullName?.familyName ?? "")")
                print("User Email: \(credential.email ?? "")")
                #endif
                appleButton.isHidden = false
                appleActivityIndicator.stopAnimating()
                var name = ""
                name += credential.fullName?.givenName ?? ""
                if !name.isEmpty { name += " " }
                name += credential.fullName?.familyName ?? ""
                AuthService().appleAuth(name: name.isEmpty ? nil : name,
                                          code: code) { (isSuccess) in
                    self.appleButton.isHidden = false
                    self.appleActivityIndicator.stopAnimating()
                    if isSuccess { self.continueToNextScreen() }
                }
            } else {
                NetworkError.unknownError.parse()
            }
        }
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding
@available(iOS 13.0, *)
extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
