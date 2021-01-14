//
//  Checksum.swift
//  stori
//
//  Created by Alex on 11.01.2021.
//

import Foundation
import CommonCrypto

struct Checksum {
    private init() {}

    /// This function hashes the `Data` with selected hash method, for chunked upload.
    /// In this case the hash is verified on the server to validate the file uploaded
    ///
    /// - Parameter data: `Data` which will be hashed.
    /// - Parameter algorithm: Selected algorythm for hashing data. For our server is used `md5`.
    ///
    /// - Returns: `String` hash value.
    static func hash(data: Data, using algorithm: HashAlgorithm) -> String {
        /// Creates an array of unsigned 8 bit integers that contains zeros equal in amount to the digest length
        var digest = [UInt8](repeating: 0, count: algorithm.digestLength())

        /// Call corresponding digest calculation
        data.withUnsafeBytes {
            algorithm.digestCalculation(data: $0.baseAddress, len: UInt32(data.count), digestArray: &digest)
        }

        var hashString = ""
        /// Unpack each byte in the digest array and add them to the hashString
        for byte in digest {
            hashString += String(format: "%02x", UInt8(byte))
        }

        return hashString
    }

    /**
    * Hash using CommonCrypto
    * API exposed from CommonCrypto-60118.50.1:
    * https://opensource.apple.com/source/CommonCrypto/CommonCrypto-60118.50.1/include/CommonDigest.h.auto.html
    **/
    enum HashAlgorithm {
        case md5
        case sha256

        func digestLength() -> Int {
            switch self {
            case .md5:
                return Int(CC_MD5_DIGEST_LENGTH)
            case .sha256:
                return Int(CC_SHA256_DIGEST_LENGTH)
            }
        }

        /// CC_[HashAlgorithm] performs a digest calculation and places
        /// the result in the caller-supplied buffer for digest
        /// Calls the given closure with a pointer to the underlying unsafe bytes of the data's contiguous storage.
        func digestCalculation(data: UnsafeRawPointer!, len: UInt32, digestArray: UnsafeMutablePointer<UInt8>!) {
            switch self {
            case .md5:
                CC_MD5(data, len, digestArray)
            case .sha256:
                CC_SHA256(data, len, digestArray)
            }
        }
    }
}
