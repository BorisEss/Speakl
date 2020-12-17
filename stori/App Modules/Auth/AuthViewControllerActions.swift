//
//  AuthViewControllerActions.swift
//  stori
//
//  Created by Alex on 04.12.2020.
//

import Foundation

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
        
        AuthPresenter().logIn(email: email,
                              password: password) { isSuccess in
            self.nextButton.isHidden = false
            self.progressActivityIndicator.stopAnimating()
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.socialView.isUserInteractionEnabled = true
            self.firstBottomButton.isEnabled = true
            self.secondBottomButton.isEnabled = true
            if isSuccess {
                Router.load()
            }
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
            AuthPresenter().signUp(username: username,
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
                if isSuccess {
                    Router.load()
                }
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
        
        AuthPresenter().forgotPassword(email: email) { isSuccess in
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
            
            AuthPresenter().resetPassword(code: code,
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
}
