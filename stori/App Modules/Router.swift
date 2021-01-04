//
//  Router.swift
//  stori
//
//  Created by Alex on 03.12.2020.
//

import UIKit

class Router {
    
    static func load() {
        if !(UIApplication.getTopViewController() is RootViewController) {
            UIApplication.getTopViewController()?.dismiss(animated: true, completion: nil)
        }
        
        if !DefaultSettings.finishedTutorial {
            showTutorial()
            return
        }
        if !KeychainManager.shared.isLoggedIn() {
            showAuth()
            return
        }
        if KeychainManager.shared.isLoggedIn(),
           Storage.shared.currentUser?.userStatus != .completed {
            finishSignUp()
            return
        }
        showMainScreen()
    }
    
    static func showTutorial() {
        if UIApplication.getTopViewController() is RootViewController {
            UIApplication.getTopViewController()?.performSegue(withIdentifier: "showTutorial", sender: nil)
        }
    }
    
    static func showAuth() {
        if UIApplication.getTopViewController() is RootViewController {
            UIApplication.getTopViewController()?.performSegue(withIdentifier: "showAuth", sender: nil)
        }
    }
    
    static func finishSignUp() {
        if UIApplication.getTopViewController() is RootViewController {
            UIApplication.getTopViewController()?.performSegue(withIdentifier: "showFinishSignUp", sender: nil)
        }
    }
    
    static func showMainScreen() {
        if UIApplication.getTopViewController() is RootViewController {
            UIApplication.getTopViewController()?.performSegue(withIdentifier: "showMain", sender: nil)
        }
    }
}
