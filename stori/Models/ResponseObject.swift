//
//  ResponseObject.swift
//  stori
//
//  Created by Alex on 03.12.2020.
//

import Foundation

struct ResponseObject<T: Decodable>: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [T]
}
