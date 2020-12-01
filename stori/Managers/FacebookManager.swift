//
//  FacebookManager.swift
//  stori
//
//  Created by Alex on 30.11.2020.
//

import Foundation
import FBSDKLoginKit

class Facebook {
    /// This function launches facebook authentication inside web browser,
    /// or redirects to Facebook application, to give permissions to log in inside the app.
    ///
    /// - Parameter view: View Controller which will present Facebook authentication screen
    /// - Parameter completed: Completion handler which will be called when authentication was successfully completed.
    ///  This handler will return a `string` whith token.
    /// - Parameter failed: Completion handler which will be called when authentication failed or user canceled it.
    /// This handler will return an error `string` or `nil` if user canceled authentication.
    ///
    public static func auth(view: UIViewController!,
                            completion: @escaping (_ result: Result<String, NetworkError>) -> Void) {
        Facebook.logOut()
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: view) { (result, error) -> Void in
            if error == nil {
                let fbloginresult: LoginManagerLoginResult = result!
                if (result?.isCancelled)! {
                    completion(.failure(.facebookCanceled))
                    return
                }
                if fbloginresult.token?.permissions.contains("email") ?? false {
                    completion(.success(AccessToken.current?.tokenString ?? ""))
                } else {
                    completion(.failure(.facebookFailed))
                }
            }
        }
    }
    
    /// This function logs out user from Facebook inside the application.
    ///
    public static func logOut() {
        if AccessToken.current != nil {
            LoginManager().logOut()
        }
    }
    
    /// This function checks if user is logged in with facebook account.
    ///
    /// - Returns: `bool` value with status of authentication.
    ///
    public static func isLoggedIn() -> Bool {
        if AccessToken.current != nil {
            return true
        } else {
            return false
        }
    }
}
