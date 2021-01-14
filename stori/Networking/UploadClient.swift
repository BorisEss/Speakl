//
//  UploadClient.swift
//  stori
//
//  Created by Alex on 11.01.2021.
//

import UIKit
import PromiseKit

struct IdResponse: Decodable {
    var id: String
}

struct DiscardableResponse: Decodable {}

class Upload {
        
    static func image(_ image: UIImage,
                      name: String,
                      progress: @escaping (_ value: Double) -> Void,
                      completion: @escaping (_ id: String) -> Void) {
        let chunkedFile = ChunkedFile(image: image, name: name)
        upload(file: chunkedFile, progress: progress, completion: completion)
    }
//    static func video() {
//
//    }
//    static func file() {
//
//    }
    
    static func remove(file: LocalFile,
                       completion: @escaping (Bool) -> Void) {
        guard let id = file.id else { return }
        firstly {
            return Request(endpoint: Endpoints.chunkedUploadFile(id), method: .delete)
                .authorise()
                .build()
        }
        .then { (request) -> Promise<DiscardableResponse> in
            return APIClient.request(with: request)
        }
        .done { _ in
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    static private func upload(file: ChunkedFile,
                               progress: @escaping (Double) -> Void,
                               completion: @escaping (String) -> Void) {
        if file.id == nil, file.chunks.count == 1 {
            // Uploading entire file at once
            uploadEntireFileAtOnce(file: file, progress: progress) { (isSuccess) in
                if isSuccess { completion(file.id ?? "") }
            }
        } else {
            // Chunked upload
            uploadChunk(file: file, progress: progress) { (isSuccess) in
                if isSuccess { completion(file.id ?? "") }
            }
        }
    }
    
    static private func uploadEntireFileAtOnce(file: ChunkedFile,
                                               progress: @escaping (_ value: Double) -> Void,
                                               completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let chunkData = file.chunks.first?.data else { return }
        firstly {
            return Request(endpoint: Endpoints.chunkedUpload, method: .post)
                .authorise()
                .build()
        }
        .then { (request) -> Promise<IdResponse> in
            return APIClient.upload(to: request, data: [
                "md5": file.md5,
                "file": chunkData
            ], type: file.fileType,
            name: file.name) { (progressValue) in
                progress(progressValue)
            }
        }
        .done { response in
            file.id = response.id
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    static private func uploadChunk(chunkNumber: Int = 0,
                                    file: ChunkedFile,
                                    progress: @escaping (_ value: Double) -> Void,
                                    completion: @escaping (_ isSuccess: Bool) -> Void) {
        if chunkNumber >= file.chunks.count {
            finishUpload(file: file, completion: completion)
            return
        }
        firstly {
            return Request(endpoint: Endpoints.chunkedUploadFile(file.id),
                           method: .put)
                .set(headers: Headers().contentRange(start: file.chunks[chunkNumber].start,
                                                     end: file.chunks[chunkNumber].end,
                                                     size: file.size))
                .build()
        }
        .then { (request) -> Promise<IdResponse> in
            return APIClient.upload(to: request,
                                    data: ["file": file.chunks[chunkNumber].data],
                                    type: file.fileType,
                                    name: file.name) { (progressValue) in
                progress(calculateProgress(currentChunk: chunkNumber,
                                           currentProgress: progressValue,
                                           chunks: file.chunks.count))
            }
        }
        .done { response in
            if chunkNumber == 0 {
                file.id = response.id
            }
            uploadChunk(chunkNumber: chunkNumber + 1,
                        file: file,
                        progress: progress,
                        completion: completion)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    static private func finishUpload(file: ChunkedFile,
                                     completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let id = file.id else { return }
        firstly {
            return Request(endpoint: Endpoints.chunkedUploadFile(id), method: .post)
                .set(body: ["md5": file.md5])
                .authorise()
                .build()
        }
        .then { (request) -> Promise<DiscardableResponse> in
            return APIClient.request(with: request)
        }
        .done { _ in
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    static private func calculateProgress(currentChunk: Int,
                                          currentProgress: Double,
                                          chunks: Int) -> Double {
        let percentagePart: Double = 1.0 / Double(chunks)
        return (Double(currentChunk) + currentProgress) * percentagePart
    }
}
