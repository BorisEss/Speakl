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
    
    // MARK: - Subscriptions
    public static let verifyReceipt = user.appendingPathComponent("check-receipt/")
    
    // MARK: - Languages
    public static let languages = api.appendingPathComponent("languages/")
    public static let levels = api.appendingPathComponent("levels/")
    public static func languageLevel(langId: Int) -> URL {
        return languages.appendingPathComponent("\(langId)/levels/")
    }
    
    // MARK: - Skills
    public static let skills = api.appendingPathComponent("skills/")
    
    // MARK: - Interests
    public static let interests = topics
    
    // MARK: - Chunked Upload
    public static let chunkedUpload = api.appendingPathComponent("chunk-uploads/")
    public static func chunkedUploadFile(_ file: String?) -> URL {
        guard let file = file else { return chunkedUpload }
        let chunkedUpload = api.appendingPathComponent("chunk-uploads")
        return chunkedUpload.appendingPathComponent("\(file)/")
    }
    
    // MARK: - Teacher Network
    public static let joinTN = user.appendingPathComponent("teacher-experiences/")
    
    // MARK: - Create Story
    public static let createStory = api.appendingPathComponent("stories-group/")
    public static func updateCreatedStory(with id: Int) -> URL {
        return api.appendingPathComponent("stories-group/\(id)/")
    }
    public static let topics = api.appendingPathComponent("topics/")
    public static let categories = api.appendingPathComponent("categories/")
    public static let subCategories = api.appendingPathComponent("sub-categories/")
    public static let covers = api.appendingPathComponent("covers/")
    public static let sounds = api.appendingPathComponent("musics/")
    public static func chapters(storyId: Int) -> URL {
        return api.appendingPathComponent("stories-group/\(storyId)/stories/")
    }
    public static func updateCreatedStoryChapter(chapterId: Int) -> URL {
        return api.appendingPathComponent("stories/\(chapterId)/")
    }
    
    // MARK: - Grammar
    public static let grammar = api.appendingPathComponent("grammar/")
    
    // MARK: - Vocabulary
    public static let vocabulary = api.appendingPathComponent("words/lists/")
    public static func vocabulary(by id: Int) -> URL {
        return api.appendingPathComponent("words/lists/\(id)/words/")
    }
    
    // MARK: - Story parts
    public static func storyParts(chapterId: Int) -> URL {
        return api.appendingPathComponent("stories/\(chapterId)/parts/")
    }
    public static func storyPart(partId: Int) -> URL {
        return api.appendingPathComponent("story-parts/\(partId)/")
    }
    public static func checkWords(chapterId: Int) -> URL {
        return api.appendingPathComponent("stories/\(chapterId)/parts/check/")
    }
}
