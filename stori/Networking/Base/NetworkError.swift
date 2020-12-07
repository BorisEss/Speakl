//
//  NetworkError.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation

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
}

extension NetworkError {
    func parse() {
        switch self {
        case .requestBuilderFailed:
            Toast.error("common_request_build_failed".localized)
        case .noAuthenticationProvided:
            Toast.error("common_no_authentication".localized)
        case .error(let message):
            Toast.error(message)
        case .serverError:
            Toast.error("common_server_error".localized)
        case .unknownError:
            Toast.error("common_error_message_something_went_wrong".localized)
        case .notFound:
            Toast.error("common_not_found".localized)
        case .failedDecodingResponse:
            Toast.error("common_failed_deconding_response".localized)
        case .facebookCanceled:
            break
        case .facebookFailed:
            Toast.error("common_failed_facebook".localized)
        }
    }
}

extension Error {
    func parse() {
        if let error = self as? NetworkError {
            error.parse()
        } else {
            print(self.localizedDescription)
            // TODO: Crashlytics to send unknown error received
        }
    }
}
