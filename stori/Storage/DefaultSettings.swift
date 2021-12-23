//
//  DefaultSettings.swift
//  stori
//
//  Created by Alex on 21.11.2020.
//

import Foundation

class DefaultSettings {
    public static var finishedTutorial: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "finishedTutorial")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "finishedTutorial")
            UserDefaults.standard.synchronize()
        }
    }
    
    public static var hasShownInProgressTutorial: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "hasShownInProgressTutorial")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasShownInProgressTutorial")
            UserDefaults.standard.synchronize()
        }
    }
    
    public static var appLanguage: String {
        get {
            if let lang = UserDefaults.standard.string(forKey: "appLanguage") {
                return lang
            }
            if let lang = Locale.current.languageCode {
                return lang
            }
            return "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appLanguage")
            UserDefaults.standard.synchronize()
        }
    }
}
