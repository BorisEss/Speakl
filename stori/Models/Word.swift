//
//  Word.swift
//  stori
//
//  Created by Alex on 30.01.2021.
//

import Foundation

struct Word: Decodable {
    var id: Int
    var word: String
}

struct VocabularyWord: Decodable {
    var id: Int
    var word: String
    var definition: String?
    var url: String?
}
