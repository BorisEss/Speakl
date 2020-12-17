//
//  RootViewController.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit
import PromiseKit

class RootViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
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
            error.parse()
        }
    }
}
