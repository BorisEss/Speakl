//
//  RootViewController.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit
import PromiseKit

class RootViewController: UIViewController {
    
    private var tripleTap = UITapGestureRecognizer()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
              
        tripleTap = UITapGestureRecognizer(target: self, action: #selector(goToAuthScreen))
        tripleTap.numberOfTapsRequired = 3
        logoImageView.addGestureRecognizer(tripleTap)
        
        retryButton.setTitle("common_retry".localized, for: .normal)
        contactUsButton.setTitle("common_contact_us".localized, for: .normal)
        load()
    }
    
    @IBAction func contactUsButtonPressed(_ sender: Any) {
        sendEmail(emailAddress: contactEmail)
    }
    
    @IBAction func retryPressed(_ sender: Any) {
        load()
    }
    
    private func load() {
        activityIndicator.startAnimating()
        retryButton.isHidden = true
        contactUsButton.isHidden = true
        firstly {
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
        KeychainManager.shared.token = nil
        Router.load()
    }
}
