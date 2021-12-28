//
//  SettingsViewController.swift
//  stori
//
//  Created by Alex on 08.04.2021.
//

import UIKit
import StoreKit
import GoogleSignIn

class SettingsViewController: UIViewController {
    
    private enum BrowserType {
        case termsAndConditions
        case privacyPolicy
    }
    
    private var browserType: BrowserType = .termsAndConditions
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var passwordSection: UIView!
    
    @IBOutlet weak var membershipSubtitle: UILabel!
    @IBOutlet weak var getPremiumView: UIView!
    
    @IBOutlet weak var becomeATeacherSection: UIView!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        loadVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (tabBarController as? MainTabBarViewController)?.setNonTransparent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? AppShadowNavigationViewController,
           let firstVc = nextVc.viewControllers.first as? WebBrowserViewController {
            firstVc.navbarWasHidden = true
            switch browserType {
            case .termsAndConditions:
                firstVc.title = "common_terms_and_conditions".localized
                firstVc.url = Endpoints.termsAndConditions
            case .privacyPolicy:
                firstVc.title = "common_privacy_policy".localized
                firstVc.url = Endpoints.privacyPolicy
            }
        }
        
        if segue.identifier == "changeNativeLanguage",
           let nextVc = segue.destination as? AppShadowNavigationViewController,
           let firstVc = nextVc.viewControllers.first as? UpdateLanguageViewController {
            firstVc.type = .native
        }
        
        if segue.identifier == "changeLearningLevel",
           let nextVc = segue.destination as? AppShadowNavigationViewController,
           let firstVc = nextVc.viewControllers.first as? UpdateLanguageViewController {
            firstVc.type = .learning
        }
        
        if segue.identifier == "checkJoinTeacherNetwork",
           let nextVc = segue.destination as? AppShadowNavigationViewController,
           let firstVc = nextVc.viewControllers.first as? JoinTNSuccessMessageViewController {
            firstVc.isCheck = true
            nextVc.hidesBottomBarWhenPushed = true
        }
    }
    
    @IBAction func editUserImageButtonPressed(_ sender: Any) {
        let pickerAlertController: UIAlertController
        if UIDevice.current.userInterfaceIdiom == .pad {
            pickerAlertController = UIAlertController(title: nil,
                                                      message: "settings_choose_photo".localized,
                                                      preferredStyle: .alert)
        } else {
            pickerAlertController = UIAlertController(title: nil,
                                                      message: "settings_choose_photo".localized,
                                                      preferredStyle: .actionSheet)
        }
        
        let cancelAction = UIAlertAction(title: "common_cancel_title".localized, style: .cancel) { _ in }
        pickerAlertController.addAction(cancelAction)
        
        let cameraAction = UIAlertAction(title: "settings_camera".localized, style: .default) { _ in
            ImagePicker.pickImage(from: .camera,
                                  frontCamera: true,
                                  isSquare: true,
                                  compress: true) { [weak self] (file) in
                self?.uploadAvatar(image: file.image)
            }
        }
        pickerAlertController.addAction(cameraAction)
        let libraryAction = UIAlertAction(title: "settings_library".localized, style: .default) { _ in
            ImagePicker.pickImage(from: .library,
                                  isSquare: true,
                                  compress: true) { [weak self] (file) in
                self?.uploadAvatar(image: file.image)
            }
        }
        pickerAlertController.addAction(libraryAction)
        self.present(pickerAlertController, animated: true)
    }
    
    @IBAction func becomeATeacherButtonPressed(_ sender: Any) {
        if let tnStatus = Storage.shared.currentUser?.teacherExperience?.status {
            if tnStatus == .inReview {
                performSegue(withIdentifier: "checkJoinTeacherNetwork", sender: nil)
            }
        } else {
            performSegue(withIdentifier: "showJoinTeacherNetwork", sender: nil)
        }
    }
    
    @IBAction func rateUsButtonPressed(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func contactUsButtonPressed(_ sender: Any) {
        sendEmail(emailAddress: contactEmail)
    }
    
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        browserType = .privacyPolicy
        performSegue(withIdentifier: "showWebBrowser", sender: nil)
    }
    
    @IBAction func termsAndConditionsButtonPressed(_ sender: Any) {
        browserType = .termsAndConditions
        performSegue(withIdentifier: "showWebBrowser", sender: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let logoutAlertController: UIAlertController
        if UIDevice.current.userInterfaceIdiom == .pad {
            logoutAlertController = UIAlertController(title: nil,
                                                      message: "settings_sign_out_question".localized,
                                                      preferredStyle: .alert)
        } else {
            logoutAlertController = UIAlertController(title: nil,
                                                      message: "settings_sign_out_question".localized,
                                                      preferredStyle: .actionSheet)
        }
        
        let cancelAction = UIAlertAction(title: "common_cancel_title".localized, style: .cancel) { _ in }
        logoutAlertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "settings_sign_out".localized, style: .destructive) { _ in
            Facebook.logOut()
//            GIDSignIn.sharedInstance().signOut()
            Storage.shared.currentUser = nil
            KeychainManager.shared.token = nil
            Router.load()
        }
        logoutAlertController.addAction(destroyAction)
        self.present(logoutAlertController, animated: true)
    }
    
    private func setUpNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func loadData() {
        if let avatar = Storage.shared.currentUser?.avatar {
            userImageView.load(stringUrl: avatar)
        }
        userNameLabel.text = Storage.shared.currentUser?.username
        passwordSection.isHidden = Storage.shared.currentUser?.userSignUpType != .email
        getPremiumView.isHidden = Storage.shared.currentUser?.isPremium ?? false
        if Storage.shared.currentUser?.isPremium ?? false {
            let productList = InAppPurchaseManager.shared.products
            if let currentId = Storage.shared.currentUser?.subscriptionId,
               let premiumType = productList.first(where: {$0.productIdentifier == currentId}) {
                membershipSubtitle.text = premiumType.localizedDescription
            } else {
                membershipSubtitle.text = "settings_membership_premium".localized
            }
        } else {
            membershipSubtitle.text = "settings_membership_free".localized
        }
        if let tnStatus = Storage.shared.currentUser?.teacherExperience?.status {
            becomeATeacherSection.isHidden = tnStatus == .approved
        } else {
            becomeATeacherSection.isHidden = false
        }
    }
    
    private func loadVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = String(format: "settings_version".localized, version)
        } else {
            self.versionLabel.text = ""
        }
    }
    
    private func uploadAvatar(image: UIImage?) {
        if let image = image {
            UserClient.updateUserImage(image: image)
                .ensure {
                    self.loadData()
                }
                .done { (_) in
                    Toast.success("settings_avatar_success".localized)
                }
                .catch { (error) in
                    error.parse()
                }
        } else {
            Toast.error("settings_avatar_failed".localized)
        }
    }
}
