//
//  LearningLanguage.swift
//  stori
//
//  Created by Alex on 30.12.2020.
//

import Foundation

struct LearningLanguage: Decodable {
    var langId: Int?
    var level: LanguageLevel?
    var interests: [Interest]
    
    enum CodingKeys: String, CodingKey {
        case langId = "lang_id"
        case level = "level_id"
        case interests
    }
}
