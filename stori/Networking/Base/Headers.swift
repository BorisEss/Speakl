//
//  Headers.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation

//TODO: Update fields
struct Headers {
    /// Basic headers necessary for the requests.
    ///
    let basic: HeadersDict = [
        "Accept": "application/json",
        "Content-Type": "application/json",
//        "Accept-Language": DefaultSettingsManager.language.rawValue
    ]
    
    /// Authorized headers with token form Keychain
    ///
    let authorized: HeadersDict = [
        "Accept": "application/json",
        "Content-Type": "application/json",
//        "Accept-Language": DefaultSettingsManager.language.rawValue,
        "Authorization": "Bearer \(KeychainManager.shared.token ?? "")"
    ]
}
