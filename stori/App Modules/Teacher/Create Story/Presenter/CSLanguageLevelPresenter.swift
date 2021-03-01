//
//  CSLanguageLevelPresenter.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

final class CSLanguageLevelPresenter {
    func getLanguageLevels(language: Language) -> Promise<[LanguageLevel]> {
        return LanguagePresenter().getLanguageLevels(language: language)
    }
    
    func createLanguageLevel(levelName: String) -> Promise<LanguageLevel> {
        return Promise<LanguageLevel> { promise in
            firstly {
                return Request(endpoint: Endpoints.levels, method: .post)
                    .authorise()
                    .set(body: [
                        "long_name": ["en": levelName]
                    ])
                    .build()
            }
            .then { (request) -> Promise<LanguageLevel> in
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
