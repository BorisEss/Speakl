//
//  Checksum.swift
//  stori
//
//  Created by Alex on 11.01.2021.
//

import Foundation
import CommonCrypto
import CryptoKit

struct Checksum {
    static func hash(data: Data) -> String {
        if #available(iOS 13.0, *) {
            let hash = Insecure.MD5.hash(data: data)
            return String((hash.description.split(separator: " ").last) ?? "")
        } else {
            let length = Int(CC_MD5_DIGEST_LENGTH)
            var digest = [UInt8](repeating: 0, count: length)
            _ = data.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
                return ""
            }
            return (0 ..< length).reduce("") {
                $0 + String(format: "%02x", digest[$1])
            }
        }
    }
}
