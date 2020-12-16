//
//  CurrentUser.swift
//  stori
//
//  Created by Alex on 30.11.2020.
//

import Foundation

struct CurrentUser: Decodable {
    var id: Int
    var langToLearn: Int?
    var langToLearnLevel: Int?
    var nativeLang: Int?
    var skills: [Skill]
    var interests: [Interest]
    
    enum CodingKeys: String, CodingKey {
        case id
        case nativeLang = "native_lang"
        case langToLearnLevel = "lang_to_learn_level"
        case langToLearn = "lang_to_learn"
        case skills
        case interests
    }
}
