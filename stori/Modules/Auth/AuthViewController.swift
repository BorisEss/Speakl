//
//  AuthViewController.swift
//  stori
//
//  Created by Alex on 22.11.2020.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

enum AuthScreenType {
    case login
    case signup
    case forgotPassword
    case resetPassword
}

class AuthViewController: UIViewController {
    
    // MARK: - Internal proprietes
    private lazy var keyboardHandler = KeyboardApperenceHandler()
    var authType: AuthScreenType = .login {
        didSet {
            updateView()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var bottomImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var logoSection: UIStackView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: RegularTextField!
    
    @IBOutlet weak var emailTextField: RegularTextField!
    
    @IBOutlet weak var codeTextField: RegularTextField!
    
    @IBOutlet weak var passwordTextField: RegularTextField!
    
    @IBOutlet weak var repeatPasswordTextField: RegularTextField!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var socialView: UIStackView!
    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var facebookActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var googleActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var appleActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var bottomButtonsView: UIStackView!
    @IBOutlet weak var firstBottomButton: UIButton!
    @IBOutlet weak var secondBottomButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        authType = .login
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.subscribe(delegate: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Button Actions
    @IBAction func languageButtonPressed(_ sender: Any) {
        // TODO: Show language view, change language and update language in view
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        dismissKeyboard()
        switch authType {
        case .login:
            logIn()
        case .signup:
            signUp()
        case .forgotPassword:
            forgotPassword()
        case .resetPassword:
            resetPassword()
        }
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        facebookButton.isHidden = true
        facebookActivityIndicator.startAnimating()
        Facebook.auth(view: self) { (result) in
            self.facebookButton.isHidden = false
            self.facebookActivityIndicator.stopAnimating()
            switch result {
            case .success(let token):
                AuthPresenter().facebookAuth(token: token) { (isSuccess) in
                    if isSuccess {
                        // TODO: Go to next page
                    }
                }
            case .failure(let error):
                error.parse()
            }
        }
    }
    
    @IBAction func googlePressed(_ sender: Any) {
        googleButton.isHidden = true
        googleActivityIndicator.startAnimating()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func applePressed(_ sender: Any) {
        appleButton.isHidden = true
        appleActivityIndicator.startAnimating()
        let appleSignInRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleSignInRequest.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [appleSignInRequest])
        controller.delegate = self
        controller.presentationContextProvider = self

        controller.performRequests()
    }
    
    @IBAction func firstBottomButtonPressed(_ sender: Any) {
        switch authType {
        case .login, .forgotPassword, .resetPassword:
            authType = .signup
        case .signup:
            authType = .login
        }
    }
    
    @IBAction func secondBottomButtonPressed(_ sender: Any) {
        switch authType {
        case .login:
            authType = .forgotPassword
        case .signup:
            // TODO: Show Terms and Conditions
            break
        case .forgotPassword, .resetPassword:
            authType = .login
        }
    }
    
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
                // TODO: Router -> Go to mai screen
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
                    // TODO: Router - go to next step of sign up
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
                    // TODO: Show success message
                    self.authType = .login
                }
            }
        }
    }
}

extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            #if DEBUG
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            #endif
            googleButton.isHidden = false
            googleActivityIndicator.stopAnimating()
            return
        }
        if let token = user.authentication.idToken {
            #if DEBUG
            print("Logged in with Google:")
            print(user.authentication.idToken ?? "") // Safe to send to the server
            print(user.userID ?? "")              // For client-side use only!
            print(user.profile.name ?? "")
            print(user.profile.email ?? "")
            #endif
            AuthPresenter().googleAuth(token: token) { (isSuccess) in
                self.googleButton.isHidden = false
                self.googleActivityIndicator.stopAnimating()
                if isSuccess {
                    // TODO: Go to next page
                }
            }
        } else {
            googleButton.isHidden = false
            googleActivityIndicator.stopAnimating()
        }
    }
}

// MARK: ASAuthorizationControllerDelegate
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
                AuthPresenter().appleAuth(name: name.isEmpty ? nil : name,
                                          code: code) { (isSuccess) in
                    self.appleButton.isHidden = false
                    self.appleActivityIndicator.stopAnimating()
                    if isSuccess {
                        // TODO: Router finish auth
                    }
                }
            } else {
                NetworkError.unknownError.parse()
            }
        }
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding
extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
