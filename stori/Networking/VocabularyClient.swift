//
//  VocabularyClient.swift
//  stori
//
//  Created by Alex on 04.05.2021.
//

import Foundation
import PromiseKit

class VocabularyClient {
    func getVocabularyId(query: QuerryDict) -> Promise<Int> {
        return Promise<Int> { promise in
            firstly {
                return Request(endpoint: Endpoints.vocabulary, method: .get)
                    .authorise()
                    .set(query: query)
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<VocabularyId>> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                guard let firstResult = response.results.first else {
                    promise.reject(NetworkError.notFound)
                    return
                }
                promise.fulfill(firstResult.id)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    func getWords(vocabularyId: Int, page: Int) -> Promise<ResponseObject<VocabularyWord>> {
        return Promise<ResponseObject<VocabularyWord>> { promise in
            firstly {
                return Request(endpoint: Endpoints.vocabulary(by: vocabularyId), method: .get)
                    .authorise()
                    .set(query: [
                        "page": "\(page)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<VocabularyWord>> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                promise.fulfill(response)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    func searchWords(vocabularyId: Int, page: Int, search: String) -> Promise<ResponseObject<VocabularyWord>> {
        return Promise<ResponseObject<VocabularyWord>> { promise in
            firstly {
                return Request(endpoint: Endpoints.vocabulary(by: vocabularyId), method: .get)
                    .authorise()
                    .set(query: [
                        "search": search,
                        "page": "\(page)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<VocabularyWord>> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                promise.fulfill(response)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
}
