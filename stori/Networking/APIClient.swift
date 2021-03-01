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
                    if response.data == nil,
                       let value = DiscardableResponse() as? T {
                        promise.fulfill(value)
                    }
                    switch response.result {
                    case .success(let value):
                        promise.fulfill(value)
                    case .failure(let error):
                        promise.reject(parseError(error: error, data: response.data))
                    }
                }
        }
    }
    
    public static func upload<T: Decodable>(to request: URLRequest,
                                            data: [String: Any],
                                            type: FileType,
                                            name: String? = nil,
                                            progress: @escaping (Double) -> Void) -> Promise<T> {
        return Promise { promise in
            AF.upload(multipartFormData: loadMultipartFormData(data: data, type: type, name: name),
                      with: request)
                .validate(statusCode: 200..<300)
                .uploadProgress { (progressValue) in
                    #if DEBUG
                    print("Upload Progress: \(progressValue.fractionCompleted * 100)")
                    #endif
                    progress(progressValue.fractionCompleted)
                }
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
    
    private static func loadMultipartFormData(data: [String: Any],
                                              type: FileType = .image,
                                              name: String? = nil) -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        
        for (key, value) in data {
            if let data = value as? Data {
                var newName: String = name ?? String.uniqueName
                var mimeType: String = ""
                switch type {
                case .image:
                    newName += ".jpeg"
                    mimeType = "image/jpeg"
                case .video:
                    newName += ".mov"
                    mimeType = "video/quicktime"
                case .audioMp3:
                    newName += ".mp3"
                    mimeType = "audio/mpeg3"
                case .audioM4a:
                    newName += ".m4a"
                    mimeType = "audio/mp4"
                case .pdf:
                    newName += ".pdf"
                    mimeType = "application/pdf"
                }
                multipartFormData.append(data,
                                         withName: key,
                                         fileName: newName,
                                         mimeType: mimeType)
                if let localData = newName.data(using: .utf8) {
                    multipartFormData.append(localData, withName: "filename")
                }
            } else if let localData = ("\(value)").data(using: .utf8) {
                multipartFormData.append(localData, withName: key)
            }
        }
        
        return multipartFormData
    }
}
