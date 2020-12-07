//
//  KeychainManager.swift
//  stori
//
//  Created by Alex on 30.11.2020.
//

import Foundation
import KeychainSwift

class KeychainManager {
    
    private var localToken: String?
    private let tokenKeyName = "appToken"
    
    public static var shared = KeychainManager()
    
    var token: String? {
        get { return localToken }
        set {
            let keychain = KeychainSwift()
            if let newToken = newValue {
                keychain.set(newToken, forKey: tokenKeyName)
            } else {
                keychain.delete(tokenKeyName)
            }
            localToken = newValue
        }
    }
    
    init() {
        let keychain = KeychainSwift()
        localToken = keychain.get(tokenKeyName)
    }
    
    func isLoggedIn() -> Bool {
        return token != nil
    }
}
