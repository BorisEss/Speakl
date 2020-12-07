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
        setUpLanguageButton()
        authType = .login
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
        }
    }
    
    // MARK: - Button Actions
    @IBAction func languageButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showLanguagePopup", sender: nil)
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
            Router.showWebBrowser(url: Endpoints.termsAndConditions)
        case .forgotPassword, .resetPassword:
            authType = .login
        }
    }
}
