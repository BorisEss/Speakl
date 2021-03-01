//
//  Language.swift
//  stori
//
//  Created by Alex on 02.12.2020.
//

import Foundation

struct Language: Decodable, Equatable {
    var id: Int
    var name: String
    var shortcut: String?
    var flag: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortcut = "short_cut"
        case flag
    }
    
    var flagUrl: URL? {
        return URL(string: flag ?? "")
    }
    
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.id == rhs.id
    }
}
