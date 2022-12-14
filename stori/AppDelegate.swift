//
//  AppDelegate.swift
//  stori
//
//  Created by Alex on 16.11.2020.
//

import UIKit
import IQKeyboardManagerSwift
#if DEBUG
import AlamofireNetworkActivityLogger
#endif
import GoogleSignIn
import FBSDKCoreKit
import SDWebImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        // MARK: IQKeyboardManager Set Up
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .systemBlue
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [
            AuthViewController.self, CommentsViewController.self
        ]

        #if DEBUG
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        #endif
        
        // Configure Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Configuring In App Purchase Manager and finishing unfinished previous transactions
        InAppPurchaseManager.shared.completeTransactions()
        
        // Hiding Back Button Title
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0),
                                                                          for: .default)
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// MARK: Google Sign In
extension AppDelegate {
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        let facebook = ApplicationDelegate.shared.application(app,
                                                              open: url,
                                                              sourceApplication: options[
                                                                UIApplication.OpenURLOptionsKey.sourceApplication
                                                                ] as? String,
                                                              annotation: options[
                                                                UIApplication.OpenURLOptionsKey.annotation
            ])

        let google = GIDSignIn.sharedInstance.handle(url)
        return facebook || google
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
