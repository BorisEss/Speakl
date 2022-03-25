//
//  RootViewController.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit
import PromiseKit
import Mute

class RootViewController: UIViewController {
    
    // MARK: - Variables
    private var tripleTap = UITapGestureRecognizer()
    
    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: AppActivityIndicator!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
              
        tripleTap = UITapGestureRecognizer(target: self, action: #selector(goToAuthScreen))
        tripleTap.numberOfTapsRequired = 3
        logoImageView.addGestureRecognizer(tripleTap)
        
        retryButton.setTitle("common_retry".localized, for: .normal)
        contactUsButton.setTitle("common_contact_us".localized, for: .normal)
        load()
    }
    
    // MARK: - Button Actions
    @IBAction func contactUsButtonPressed(_ sender: Any) {
        sendEmail(emailAddress: contactEmail)
    }
    
    @IBAction func retryPressed(_ sender: Any) {
        load()
    }
    
    // MARK: - Functions
    private func load() {
        activityIndicator.startAnimating()
        retryButton.isHidden = true
        contactUsButton.isHidden = true
        firstly {
            return Promise<Void> { promise in
                Mute.shared.check()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    learnTabIsMuted = Mute.shared.isMute
                    promise.fulfill_()
                }
            }
        }
        .then { _ -> Promise<Void> in
            return LanguageClient.getLanguages()
        }
        .then { _ -> Promise<Void> in
            return Promise<Void> { promise in
                if KeychainManager.shared.isLoggedIn() {
                    UserClient.getCurrentUser()
                        .done { _ in
                            promise.fulfill_()
                        }
                        .catch { (error) in
                            promise.reject(error)
                        }
                } else {
                    promise.fulfill_()
                }
            }
        }
        .done { _ in
            Router.load()
        }
        .catch { (error) in
            self.activityIndicator.stopAnimating()
            self.retryButton.isHidden = false
            self.contactUsButton.isHidden = false
            error.parse()
        }
    }
    
    @objc private func goToAuthScreen() {
        if !activityIndicator.isAnimating {
            KeychainManager.shared.token = nil
            Router.load()
        }
    }
}
