//
//  CSLanguageService.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

internal class CSLanguageService {
    func createLanguage(language: String) -> Promise<Language> {
        return Promise<Language> { promise in
            firstly {
                return Request(endpoint: Endpoints.languages, method: .post)
                    .authorise()
                    .set(body: [
                            "name": ["en": language]
                    ])
                    .build()
            }
            .then { (request) -> Promise<Language> in
                return APIClient.request(with: request)
            }
            .done { response in
                promise.fulfill(response)
            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
}
