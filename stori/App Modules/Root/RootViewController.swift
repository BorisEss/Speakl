//
//  RootViewController.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit
import PromiseKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        retryButton.setTitle("common_retry".localized, for: .normal)
        load()
    }
    
    @IBAction func retryPressed(_ sender: Any) {
        retryButton.isHidden = true
        load()
    }
    
    private func load() {
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
            self.retryButton.isHidden = false
            error.parse()
        }
    }
}
