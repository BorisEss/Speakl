//
//  AuthViewControllerSetUp.swift
//  stori
//
//  Created by Alex on 25.11.2020.
//

import UIKit
import Kingfisher

// MARK: UI Set Up
extension AuthViewController {
    func updateView() {
        switch authType {
        case .login:
            showLogIn()
        case .signup:
            showSignUp()
        case .forgotPassword:
            showForgotPassword()
        case .resetPassword:
            showResetPassword()
        }
        view.layoutIfNeeded()
    }
    
    func showLogIn() {
        setEmptyFields()
        titleLabel.text = "auth_vc_page_signin_subtitle".localized
        titleLabel.underline(isShown: false)
        usernameTextField.isHidden = true
        emailTextField.isHidden = false
        emailTextField.returnKeyType = .next
        codeTextField.isHidden = true
        passwordTextField.isHidden = false
        passwordTextField.returnKeyType = .done
        repeatPasswordTextField.isHidden = true
        socialView.isHidden = false
        passwordTextField.textContentType = .password
        firstBottomButton.setTitle("auth_vc_button_title_signup".localized,
                                   for: .normal)
        secondBottomButton.setTitle("auth_vc_button_title_forgot_password".localized,
                                    for: .normal)
        
        #if DEBUG
        emailTextField.text = "user@gmail.com"
        passwordTextField.text = "qwerty"
        #endif
    }
    
    func showSignUp() {
        setEmptyFields()
        titleLabel.text = "auth_vc_page_signup_subtitle".localized
        titleLabel.underline()
        usernameTextField.isHidden = false
        usernameTextField.returnKeyType = .next
        emailTextField.isHidden = false
        emailTextField.returnKeyType = .next
        codeTextField.isHidden = true
        passwordTextField.isHidden = false
        passwordTextField.returnKeyType = .next
        repeatPasswordTextField.isHidden = false
        repeatPasswordTextField.returnKeyType = .done
        socialView.isHidden = true
        passwordTextField.textContentType = .newPassword
        let ruleString = "required: lower; required: upper; required: digit; minlength: 8; maxlength: 16;"
        let rule = UITextInputPasswordRules(descriptor: ruleString)
        passwordTextField.passwordRules = rule
        repeatPasswordTextField.textContentType = .newPassword
        repeatPasswordTextField.passwordRules = rule
        firstBottomButton.setTitle("auth_vc_button_title_log_in".localized, for: .normal)
        secondBottomButton.setTitle("auth_vc_button_title_terms_and_conditions".localized,
                                    for: .normal)
    }
    
    func showForgotPassword() {
        setEmptyFields()
        titleLabel.text = "auth_vc_page_forgot_password_subtitle".localized
        titleLabel.underline()
        usernameTextField.isHidden = true
        emailTextField.isHidden = false
        emailTextField.returnKeyType = .done
        codeTextField.isHidden = true
        passwordTextField.isHidden = true
        repeatPasswordTextField.isHidden = true
        socialView.isHidden = true
        firstBottomButton.setTitle("auth_vc_button_title_signup".localized,
                                   for: .normal)
        secondBottomButton.setTitle("auth_vc_button_title_log_in".localized,
                                    for: .normal)
    }
    
    func showResetPassword() {
        setEmptyFields()
        titleLabel.text = "auth_vc_page_reset_password_subtitle".localized
        titleLabel.underline()
        usernameTextField.isHidden = true
        emailTextField.isHidden = true
        codeTextField.isHidden = false
        codeTextField.returnKeyType = .next
        passwordTextField.isHidden = false
        passwordTextField.returnKeyType = .next
        repeatPasswordTextField.isHidden = false
        repeatPasswordTextField.returnKeyType = .done
        socialView.isHidden = true
        firstBottomButton.setTitle("auth_vc_button_title_signup".localized,
                                   for: .normal)
        secondBottomButton.setTitle("auth_vc_button_title_log_in".localized,
                                    for: .normal)
    }
}

// MARK: - Other types of set up
extension AuthViewController {
    func setUpLanguage() {
        logoLabel.text = "auth_vc_page_title".localized
        usernameTextField.placeholder = "auth_vc_field_placeholder_username".localized
        emailTextField.placeholder = "auth_vc_field_placeholder_email".localized
        codeTextField.placeholder = "auth_vc_field_placeholder_otp_code".localized
        passwordTextField.placeholder = "auth_vc_field_placeholder_password".localized
        repeatPasswordTextField.placeholder = "auth_vc_field_placeholder_repeat_password".localized
        socialLabel.text = "auth_vc_social_media_option_title".localized
    }
    
    func setEmptyFields() {
        usernameTextField.text = nil
        emailTextField.text = nil
        codeTextField.text = nil
        passwordTextField.text = nil
        repeatPasswordTextField.text = nil
    }
    
    func setUpLanguageButton() {
        languageButton.kf.setImage(with: Storage.shared.currentLanguage?.flagUrl,
                                   for: .normal)
    }
}
