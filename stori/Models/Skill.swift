//
//  Skill.swift
//  stori
//
//  Created by Alex on 08.12.2020.
//

import Foundation

struct Skill: Decodable {
    var id: Int
    var name: String
    var image: String?

    var imageUrl: URL? {
        return URL(string: image ?? "")
    }
}
