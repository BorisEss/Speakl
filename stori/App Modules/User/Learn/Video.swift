//
//  Video.swift
//  stori
//
//  Created by Alex on 20.08.2021.
//

import Foundation

struct JsonVideo: Decodable {
    var videos: [Video]
}

struct Video: Decodable {
    var sources: String
    var cover: String
    var title: String
}
