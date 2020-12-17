//
//  APIClient.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation
import Alamofire
import PromiseKit

final class APIClient {
    /// Alamofire Custom manager, to create a request to the server.
    ///
    /// - Parameter request: `URLRequest` which contains the URL Request details.
    /// - Returns: This function returns a promise for `T` required.
    ///
    public static func request<T: Decodable>(with request: URLRequest) -> Promise<T> {
        return Promise { promise in
            AF.request(request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        promise.fulfill(value)
                    case .failure(let error):
                        promise.reject(parseError(error: error, data: response.data))
                    }
                }
        }
    }
    
    private static func parseError(error: AFError, data: Data?) -> Error {
        if let responseCode = error.responseCode {
            switch responseCode {
            case 400:
                if let errorString = parseError(data: data) {
                    return NetworkError.error(errorString)
                } else {
                    return NetworkError.unknownError
                }
            case 403:
                KeychainManager.shared.token = nil
                Router.load()
                return NetworkError.noAuthenticationProvided
            case 404:
                if let errorString = parseError(data: data) {
                    return NetworkError.error(errorString)
                } else {
                    return NetworkError.notFound
                }
            case 500...599: return NetworkError.serverError
            default: return error
            }
        } else if error.isResponseSerializationError {
            return NetworkError.failedDecodingResponse
        } else {
            return error
        }
    }
    
    private static func parseError(data: Data?) -> String? {
        if let data = data?.toDictionary(),
           let firstElement = data.first,
           let errorsArray = firstElement.value as? [String],
           let firstError = errorsArray.first {
            return firstError
        }
        return nil
    }
}

struct TestTt: Decodable {
    var id: String
    var name: String?
}
