//
//  CSGrammarPresenter.swift
//  stori
//
//  Created by Alex on 20.02.2021.
//

import Foundation
import PromiseKit

class CSGrammarPresenter {
    func getGrammar(language: Language,
                    languageLevel: LanguageLevel,
                    subCategory: SubCategory) -> Promise<String> {
        return Promise<String> { promise in
            firstly {
                return Request(endpoint: Endpoints.grammar, method: .get)
                    .authorise()
                    .set(query: [
                        "language_id": "\(language.id)",
                        "level_id": "\(languageLevel.id)",
                        "sub_category_id": "\(subCategory.id)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<Grammar>> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                guard let firstResult = response.results.first else {
                    promise.reject(NetworkError.notFound)
                    return
                }
                promise.fulfill(firstResult.url) 
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
}
