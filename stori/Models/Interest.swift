//
//  Interest.swift
//  stori
//
//  Created by Alex on 15.12.2020.
//

import Foundation

struct Interest: Decodable {
    var id: Int
    var name: String
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "thumbnail"
    }
    
    var imageUrl: URL? {
        return URL(string: image ?? "")
    }
}
