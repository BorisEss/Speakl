//
//  Checksum.swift
//  stori
//
//  Created by Alex on 11.01.2021.
//

import Foundation
import CryptoKit

struct Checksum {
    static func hash(data: Data) -> String {
        let hash = Insecure.MD5.hash(data: data)
        return String((hash.description.split(separator: " ").last) ?? "")
    }
}
