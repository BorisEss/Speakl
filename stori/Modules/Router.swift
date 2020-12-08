//
//  Router.swift
//  stori
//
//  Created by Alex on 03.12.2020.
//

import UIKit

class Router {
    
    static func load() {
        if !(UIViewController.topViewController() is RootViewController) {
            UIViewController.topViewController()?.dismiss(animated: true, completion: nil)
        }
        
        if !DefaultSettings.finishedTutorial {
            showTutorial()
            return
        }
        if !KeychainManager.shared.isLoggedIn() {
            showAuth()
            return
        }
        if let user = Storage.shared.currentUser,
           user.langToLearn == nil {
            let language = Storage.shared.languages.first(where: {$0.id == user.langToLearn})
            showLanguageSelection(selected: language)
            return
        }
        showMainScreen()
    }
    
    static func showTutorial() {
        if UIViewController.topViewController() is RootViewController {
            UIViewController.topViewController()?.performSegue(withIdentifier: "showTutorial", sender: nil)
        }
    }
    
    static func showAuth() {
        if UIViewController.topViewController() is RootViewController {
            UIViewController.topViewController()?.performSegue(withIdentifier: "showAuth", sender: nil)
        }
    }
    
    static func showMainScreen() {
        fatalError("Show main screen of the app")
    }
    
    static func showWebBrowser(navigation: Bool = false, url: URL) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "WebBrowser", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "WebBrowserViewController")
        if let nextBrowserScreen = nextScreen as? WebBrowserViewController {
            nextBrowserScreen.navigation = navigation
            nextBrowserScreen.url = url
            if navigation {
                UIViewController.topViewController()?.navigationController?.pushViewController(nextBrowserScreen,
                                                                                               animated: true)
            } else {
                UIViewController.topViewController()?.present(nextBrowserScreen, animated: true)
            }
        }
    }
    
    static func showLanguageSelection(selected: Language? = nil) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "LanguageSelect", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "LanguageSelectViewController")
        if let nextScreen = controller as? LanguageSelectViewController {
            nextScreen.modalPresentationStyle = .fullScreen
            nextScreen.modalTransitionStyle = .crossDissolve
            if let language = selected {
                nextScreen.fillWith(language: language, shouldGoBack: false)
            }
            UIViewController.topViewController()?.present(nextScreen, animated: true, completion: nil)
        }
    }
    
    static func showSkillsSelection() {
        
    }
    
    static func showLanguageLevelSelection() {
        
    }
}
