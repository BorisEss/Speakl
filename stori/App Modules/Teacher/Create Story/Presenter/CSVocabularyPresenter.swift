//
//  CSVocabularyPresenter.swift
//  stori
//
//  Created by Alex on 20.02.2021.
//

import Foundation
import PromiseKit

class CSVocabularyPresenter {
    func getVocabularyId(language: Language,
                         languageLevel: LanguageLevel,
                         subCategory: SubCategory) -> Promise<Int> {
        return Promise<Int> { promise in
            firstly {
                return Request(endpoint: Endpoints.vocabulary, method: .get)
                    .authorise()
                    .set(query: [
                        "language_id": "\(language.id)",
                        "level_id": "\(languageLevel.id)",
                        "sub_category_id": "\(subCategory.id)"
                    ])
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
