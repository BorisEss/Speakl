//
//  Endpoints.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation

struct Endpoints {
        
    static private let api = base.appendingPathComponent("api")
    
    // MARK: - Others
    public static let termsAndConditions = URL(string: "https://readstori.com/terms-and-conditions")!
    public static let privacyPolicy = URL(string: "https://readstori.com/privacy-policy")!
    
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
    public static let updateInterests = user.appendingPathComponent("set-interests/")
    
    // MARK: - Languages
    public static let languages = api.appendingPathComponent("languages/")
    public static func languageLevel(langId: Int) -> URL {
        return languages.appendingPathComponent("\(langId)/levels/")
    }
    
    // MARK: - Skills
    public static let skills = api.appendingPathComponent("skills/")
    
    // MARK: - Interests
    public static let interests = api.appendingPathComponent("interests/")
    
    // MARK: - Chunked Upload
    public static let chunkedUpload = api.appendingPathComponent("chunk-uploads/")
    public static func chunkedUploadFile(_ file: String?) -> URL {
        guard let file = file else { return chunkedUpload }
        let chunkedUpload = api.appendingPathComponent("chunk-uploads")
        return chunkedUpload.appendingPathComponent("\(file)/")
    }
    
    // MARK: - Teacher Network
    public static let joinTN = user.appendingPathComponent("teacher-experiences/")
}
