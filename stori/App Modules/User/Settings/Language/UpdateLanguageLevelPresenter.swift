//
//  UpdateLanguageLevelPresenter.swift
//  stori
//
//  Created by Alex on 04.05.2021.
//

import Foundation
import PromiseKit

class UpdateLanguageLevelPresenter {
    func getGrammar(language: Language,
                    languageLevel: LanguageLevel) -> Promise<String> {
        return GrammarClient().getGrammar(query: [
            "language_id": "\(language.id)",
            "level_id": "\(languageLevel.id)"
        ])
    }
    
    func getWords(language: Language,
                  languageLevel: LanguageLevel,
                  page: Int) -> Promise<ResponseObject<VocabularyWord>> {
        return Promise<ResponseObject<VocabularyWord>> { promise in
            firstly {
                return Request(endpoint: Endpoints.vocabularyWords, method: .get)
                    .authorise()
                    .set(query: [
                        "wordlist__language_id": "\(language.id)",
                        "wordlist__level_id": "\(languageLevel.id)",
                        "ordering": "word",
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
