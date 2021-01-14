//
//  Headers.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation

struct Headers {
    /// Basic headers necessary for the requests.
    ///
    let basic: HeadersDict = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Accept-Language": Storage.shared.currentLanguage?.shortcut ?? "en"
    ]
    
    /// Authorized headers with token form Keychain
    ///
    let authorized: HeadersDict = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Accept-Language": Storage.shared.currentLanguage?.shortcut ?? "en",
        "Authorization": "Bearer \(KeychainManager.shared.token ?? "")"
    ]
    
    func contentRange(start: Int, end: Int, size: Int) -> HeadersDict {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Accept-Language": Storage.shared.currentLanguage?.shortcut ?? "en",
            "Authorization": "Bearer \(KeychainManager.shared.token ?? "")",
            "Content-Range": "bytes \(start)-\(end)/\(size)"
        ]
    }
}
