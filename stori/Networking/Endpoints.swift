//
//  Endpoints.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation

struct Endpoints {
        
    static private let api = base.appendingPathComponent("api")
    
    // MARK: - Auth
    private static let auth = api.appendingPathComponent("auth")
    public static let login = auth.appendingPathComponent("login/")
    public static let facebookLogin = auth.appendingPathComponent("fb-login/")
    public static let appleLogin = auth.appendingPathComponent("apple-login/")
    public static let googleLogin = auth.appendingPathComponent("google-login-ios/")
    public static let register = auth.appendingPathComponent("register/")
    public static let requestResetPassword = auth.appendingPathComponent("request-code/")
    public static let resetPassword = auth.appendingPathComponent("request-reset-password/")
    
    // MARK: - User
    private static let user = api.appendingPathComponent("users")
    public static let currentUser = user.appendingPathComponent("me/")
}
