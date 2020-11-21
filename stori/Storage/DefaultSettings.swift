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
}
