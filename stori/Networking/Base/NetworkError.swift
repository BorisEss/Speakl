//
//  NetworkError.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation

// TODO: Finish errors

/// Possible networking error
///
public enum NetworkError: Error {
    case requestBuilderFailed
    case noAuthenticationProvided
    case error(_: String)
    case serverError
    case unknownError
    case notFound
    case failedDecodingResponse
    case facebookCanceled
    case facebookFailed
//    case dataIsNotEncodable(_: Any)
//    case noInternetConnection
//    case failedToDecodeJSON
//    case requestTimeout
    
//    case failedToEncodeImage
}

extension NetworkError {
    func parse() {
//        switch self {
//        }
    }
}

extension Error {
    func parse() {
        if let error = self as? NetworkError {
            error.parse()
        } else {
            print(self.localizedDescription)
            print("Error parse")
        }
    }
}
