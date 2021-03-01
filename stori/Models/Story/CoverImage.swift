//
//  CoverImage.swift
//  stori
//
//  Created by Alex on 27.01.2021.
//

import Foundation

struct CoverImage: Decodable {
    var id: Int
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "upload"
    }
    
    var imageUrl: URL? {
        return URL(string: image ?? "")
    }
}
