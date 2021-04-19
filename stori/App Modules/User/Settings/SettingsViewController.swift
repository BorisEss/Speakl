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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var membershipSubtitle: UILabel!
    @IBOutlet weak var getPremiumView: UIView!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        loadVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
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
    
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func termsAndConditionsButtonPressed(_ sender: Any) {
        
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
            GIDSignIn.sharedInstance().signOut()
            Storage.shared.currentUser = nil
            KeychainManager.shared.token = nil
            Router.load()
        }
        logoutAlertController.addAction(destroyAction)
        self.present(logoutAlertController, animated: true)
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.2
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 8)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func loadData() {
        if let avatar = Storage.shared.currentUser?.avatar {
            userImageView.load(stringUrl: avatar)
        }
        userNameLabel.text = Storage.shared.currentUser?.username
        getPremiumView.isHidden = Storage.shared.currentUser?.isPremium ?? false
        if Storage.shared.currentUser?.isPremium ?? false {
            membershipSubtitle.text = "settings_membership_premium".localized
        } else {
            membershipSubtitle.text = "settings_membership_free".localized
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
