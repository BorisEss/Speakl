//
//  BackgroundAudio.swift
//  stori
//
//  Created by Alex on 28.01.2021.
//

import Foundation

typealias Duration = (minutes: Int, seconds: Int)

struct BackgroundAudio: Decodable {
    var id: Int
    var name: String?
    var author: String?
    var album: String?
    var file: String?
    var duration: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case file = "upload"
        case author
        case album
        case duration
    }
    
    var fileUrl: URL? {
        return URL(string: file ?? "")
    }
    
    var detailedDuration: Duration {
        guard let duration = duration else { return (0, 0) }
        let min: Int = duration / 60
        let sec: Int = duration % 60
        return (min, sec)
    }
}
