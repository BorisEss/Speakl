//
//  AuthViewControllerActions.swift
//  stori
//
//  Created by Alex on 04.12.2020.
//

import Foundation
import SPPermissions

extension AuthViewController {
    // MARK: - Auth Actions
    func logIn() {
        if !emailTextField.validateEmail() { return }
        if !passwordTextField.validatePassword() { return }

        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
      
        nextButton.isHidden = true
        progressActivityIndicator.startAnimating()
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        socialView.isUserInteractionEnabled = false
        firstBottomButton.isEnabled = false
        secondBottomButton.isEnabled = false
        
        AuthService().logIn(email: email,
                              password: password) { isSuccess in
            self.nextButton.isHidden = false
            self.progressActivityIndicator.stopAnimating()
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.socialView.isUserInteractionEnabled = true
            self.firstBottomButton.isEnabled = true
            self.secondBottomButton.isEnabled = true
            if isSuccess { self.continueToNextScreen() }
        }
    }
    
    func signUp() {
        if !usernameTextField.validate() { return }
        if !emailTextField.validateEmail() { return }
        if !passwordTextField.validatePassword() { return }
        if !repeatPasswordTextField.validatePassword() { return }
        
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text  else { return }
        guard let password = passwordTextField.text else { return }
        guard let passwordConfirmation = repeatPasswordTextField.text else { return }
        
        if password != passwordConfirmation {
            NetworkError.error("auth_vc_error_passwords_not_match".localized).parse()
        } else {
            nextButton.isHidden = true
            progressActivityIndicator.startAnimating()
            usernameTextField.isEnabled = false
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            repeatPasswordTextField.isEnabled = false
            firstBottomButton.isEnabled = false
            secondBottomButton.isEnabled = false
            AuthService().signUp(username: username,
                                   email: email,
                                   password: password) { isSuccess in
                self.nextButton.isHidden = false
                self.progressActivityIndicator.stopAnimating()
                self.usernameTextField.isEnabled = true
                self.emailTextField.isEnabled = true
                self.passwordTextField.isEnabled = true
                self.repeatPasswordTextField.isEnabled = true
                self.firstBottomButton.isEnabled = true
                self.secondBottomButton.isEnabled = true
                if isSuccess { self.continueToNextScreen() }
            }
        }
    }
    
    func forgotPassword() {
        if !emailTextField.validateEmail() { return }
        
        guard let email = emailTextField.text else { return }
        
        nextButton.isHidden = true
        progressActivityIndicator.startAnimating()
        emailTextField.isEnabled = false
        firstBottomButton.isEnabled = false
        secondBottomButton.isEnabled = false
        
        AuthService().forgotPassword(email: email) { isSuccess in
            self.nextButton.isHidden = false
            self.progressActivityIndicator.stopAnimating()
            self.emailTextField.isEnabled = true
            self.firstBottomButton.isEnabled = true
            self.secondBottomButton.isEnabled = true
            if isSuccess {
                DispatchQueue.main.async {
                    self.authType = .resetPassword
                }
            }
        }
    }
    
    func resetPassword() {
        if !codeTextField.validate() { return }
        if !passwordTextField.validatePassword() { return }
        if !repeatPasswordTextField.validatePassword() { return }
        
        guard let code = codeTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let passwordConfirmation = repeatPasswordTextField.text else { return }
        
        if password != passwordConfirmation {
            NetworkError.error("auth_vc_error_passwords_not_match".localized).parse()
        } else {
            nextButton.isHidden = true
            progressActivityIndicator.startAnimating()
            codeTextField.isEnabled = false
            passwordTextField.isEnabled = false
            repeatPasswordTextField.isEnabled = false
            firstBottomButton.isEnabled = false
            secondBottomButton.isEnabled = false
            
            AuthService().resetPassword(code: code,
                                          password: password) { (isSuccess) in
                self.nextButton.isHidden = false
                self.progressActivityIndicator.stopAnimating()
                self.codeTextField.isEnabled = true
                self.passwordTextField.isEnabled = true
                self.repeatPasswordTextField.isEnabled = true
                self.firstBottomButton.isEnabled = true
                self.secondBottomButton.isEnabled = true
                
                if isSuccess {
                    Toast.success("auth_vc_alert_password_was_reset".localized)
                    self.authType = .login
                }
            }
        }
    }
    
    func continueToNextScreen() {
        if let user = Storage.shared.currentUser {
            switch user.userStatus {
            case .completed:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if SPPermissions.Permission.notification.notDetermined {
                        let permissions: [SPPermissions.Permission] = [.notification]
                        let controller = SPPermissions.list(permissions)
                        controller.showCloseButton = true
                        controller.allowSwipeDismiss = true
                        controller.delegate = self
                        controller.present(on: self)
                    } else {
                        Router.load()
                    }
                }
            case .shouldUpdateLanguage:
                performSegue(withIdentifier: Segues.continueSignUp.rawValue, sender: nil)
            }
        }
    }
}

extension AuthViewController: SPPermissionsDelegate {
    func didHidePermissions(_ permissions: [SPPermissions.Permission]) {
        Router.load()
    }
}
