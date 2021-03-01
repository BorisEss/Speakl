//
//  SectionModel.swift
//  stori
//
//  Created by Alex on 22.02.2021.
//

import Foundation

enum SectionModelType: Int, Codable {
    case text = 0
    case media = 1
}

struct SectionModel: Decodable {
    var id: Int
    var words: [Word]
    var text: String
    var type: SectionModelType
    var upload: String?
    var thumbnail: String?
    var uploadType: SectionUploadType?
    
    enum CodingKeys: String, CodingKey {
        case id
        case words
        case text
        case type
        case upload
        case thumbnail
        case uploadType = "upload_type"
    }
}

enum SectionUploadType: Int, Codable {
    case video = 0
    case image = 1
}
