//
//  AuthUser.swift
//  stori
//
//  Created by Alex on 30.11.2020.
//

import Foundation

struct AuthUser: Decodable {
    var id: Int?
    var langToLearn: Int?
    var nativeLang: Int?
    var username: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nativeLang = "native_lang"
        case langToLearn = "lang_to_learn"
        case username
        case email
    }
}
