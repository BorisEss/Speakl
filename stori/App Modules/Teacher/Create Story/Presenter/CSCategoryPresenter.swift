//
//  CSCategoryPresenter.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

final class CSCategoryPresenter {
    func getCategories(of topic: Topic,
                       page: Int = 1) -> Promise<ResponseObject<Category>> {
        return Promise<ResponseObject<Category>> { promise in
            firstly {
                return Request(endpoint: Endpoints.categories, method: .get)
                    .authorise()
                    .set(query: [
                        "topic_id": "\(topic.id)",
                        "page": "\(page)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<Category>> in
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
    func createCategory(topicId: Int, name: String) -> Promise<Category> {
        return Promise<Category> { promise in
            firstly {
                return Request(endpoint: Endpoints.categories, method: .post)
                    .authorise()
                    .set(body: [
                        "topic_id": topicId,
                        "name": [Storage.shared.currentLanguage?.shortcut ?? "en": name]
                    ])
                    .build()
            }
            .then { (request) -> Promise<Category> in
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
