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
    
    enum Segues: String {
        case languageSelector = "showLanguagePopup"
        case termsAndConditions = "showTermsAndConditions"
        case continueSignUp = "continueSignUp"
    }
    
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
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: RegularTextField!
    
    @IBOutlet weak var emailTextField: RegularTextField!
    
    @IBOutlet weak var codeTextField: RegularTextField!
    
    @IBOutlet weak var passwordTextField: RegularTextField!
    
    @IBOutlet weak var repeatPasswordTextField: RegularTextField!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var agreementLabel: UILabel!
    
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
        setUpLanguageButton()
        authType = .login
        if #available(iOS 13.0, *) {
            appleButton.isHidden = false
        } else {
            appleButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.subscribe(delegate: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? LanguagePopupViewController {
            controller.languages = Storage.shared.languages
            controller.selectedLanguage = Storage.shared.currentLanguage
            controller.completion = { language in
                Storage.shared.currentLanguage = language
                self.setUpLanguageButton()
                self.setUpLanguage()
            }
            return
        }
        if let controller = segue.destination as? WebBrowserViewController {
            controller.title = "common_terms_and_conditions".localized
            controller.url = Endpoints.termsAndConditions
            return
        }
    }
    
    // MARK: - Button Actions
    @IBAction func languageButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Segues.languageSelector.rawValue, sender: nil)
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
                    if isSuccess { self.continueToNextScreen() }
                }
            case .failure(let error):
                error.parse()
            }
        }
    }
    
    @IBAction func googlePressed(_ sender: Any) {
        googleButton.isHidden = true
        googleActivityIndicator.startAnimating()
        let signInConfig = GIDConfiguration.init(clientID: googleSignInClientId)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if let error = error {
                #if DEBUG
                print("\(error.localizedDescription)")
                #endif
                self.googleButton.isHidden = false
                self.googleActivityIndicator.stopAnimating()
                return
            }
            if let token = user?.authentication.idToken {
                #if DEBUG
                print("Logged in with Google:")
                print(user?.authentication.idToken ?? "") // Safe to send to the server
                print(user?.userID ?? "")              // For client-side use only!
                print(user?.profile?.name ?? "")
                print(user?.profile?.email ?? "")
                #endif
                AuthPresenter().googleAuth(token: token) { (isSuccess) in
                    self.googleButton.isHidden = false
                    self.googleActivityIndicator.stopAnimating()
                    if isSuccess { self.continueToNextScreen() }
                }
            } else {
                self.googleButton.isHidden = false
                self.googleActivityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func applePressed(_ sender: Any) {
        if #available(iOS 13.0, *) {
            appleButton.isHidden = true
            appleActivityIndicator.startAnimating()
            let appleSignInRequest = ASAuthorizationAppleIDProvider().createRequest()
            
            appleSignInRequest.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [appleSignInRequest])
            controller.delegate = self
            controller.presentationContextProvider = self
            
            controller.performRequests()
        }
    }
    
    @IBAction func firstBottomButtonPressed(_ sender: Any) {
        dismissKeyboard()
        switch authType {
        case .login, .forgotPassword, .resetPassword:
            authType = .signup
        case .signup:
            authType = .login
        }
    }
    
    @IBAction func secondBottomButtonPressed(_ sender: Any) {
        dismissKeyboard()
        switch authType {
        case .login:
            authType = .forgotPassword
        case .signup:
            performSegue(withIdentifier: Segues.termsAndConditions.rawValue, sender: nil)
        case .forgotPassword, .resetPassword:
            authType = .login
        }
    }
}
