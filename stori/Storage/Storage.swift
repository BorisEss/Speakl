//
//  Storage.swift
//  stori
//
//  Created by Alex on 03.12.2020.
//

import Foundation

class Storage {
    public static var shared: Storage = Storage()
    
    var languages: [Language] {
        didSet {
            if !languages.isEmpty,
               let lang = languages.first(where: { $0.shortcut == DefaultSettings.appLanguage }) {
                currentLanguage = lang
            }
        }
    }
    var currentLanguage: Language? {
        didSet {
            if let lang = currentLanguage {
                DefaultSettings.appLanguage = lang.shortcut
            }
        }
    }
    
    var currentUser: CurrentUser?
    
    init() {
        languages = []
    }
    
    func languageBy(id: Int) -> Language? {
        return languages.first(where: {$0.id == id})
    }
}
