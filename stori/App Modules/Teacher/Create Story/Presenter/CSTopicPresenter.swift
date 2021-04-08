//
//  CSTopicPresenter.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

final class CSTopicPresenter {
    func getTopics(for language: Language, page: Int = 1) -> Promise<ResponseObject<Topic>> {
        return Promise<ResponseObject<Topic>> { promise in
            firstly {
                return Request(endpoint: Endpoints.topics, method: .get)
                    .authorise(language: language)
                    .set(query: [
                        "page": "\(page)",
                        "page_size": "20",
                        "languages": "\(language.id)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<Topic>> in
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
    func createTopic(for language: Language, name: String) -> Promise<Topic> {
        return Promise<Topic> { promise in
            firstly {
                return Request(endpoint: Endpoints.topics, method: .post)
                    .authorise()
                    .set(body: [
                        "name": [Storage.shared.currentLanguage?.shortcut ?? "en": name],
                        "language_ids": language.id
                    ])
                    .build()
            }
            .then { (request) -> Promise<Topic> in
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
