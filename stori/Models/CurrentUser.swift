//
//  CurrentUser.swift
//  stori
//
//  Created by Alex on 30.11.2020.
//

import Foundation

struct CurrentUser: Decodable {
    private(set) var id: Int
    private(set) var username: String
    private(set) var email: String
    private(set) var avatar: String
    private var nativeLangId: Int?
    private var currentLearningLanguage: LearningLanguage?
    private var learningLanguagesId: [Int]
    private(set) var teacherExperience: TeacherExperience?
    private(set) var isPremium: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case avatar
        case nativeLangId = "native_lang"
        case currentLearningLanguage = "lang_to_learn"
        case learningLanguagesId = "languages"
        case teacherExperience = "teacher_experience"
        case isPremium = "is_premium"
    }
    enum Status {
        case completed
        case shouldUpdateLanguage
    }
    
    var userStatus: Status {
        if nativeLangId == nil || currentLearningLanguage == nil {
            return .shouldUpdateLanguage
        }
        return .completed
    }
    
    var nativeLanguage: Language? {
        return Storage.shared.languageBy(id: nativeLangId ?? 0)
    }
    
    var learningLanguage: Language? {
        return Storage.shared.languageBy(id: currentLearningLanguage?.langId ?? 0)
    }
    
    var interests: [Interest] {
        if let currentLearningLanguage = currentLearningLanguage {
            return currentLearningLanguage.interests
        }
       return []
    }
}

struct TeacherExperience: Decodable {
    private(set) var status: TNUserStatus
}

enum TNUserStatus: Int, Decodable {
    case inReview = 0
    case approved = 1
}
