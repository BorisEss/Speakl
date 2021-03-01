//
//  ThumbnailItem.swift
//  stori
//
//  Created by Alex on 26.01.2021.
//

import Foundation

struct ThumbnailItem: ItemProtocol {
    var id: Int
    var name: String
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "thumbnail"
    }
}
