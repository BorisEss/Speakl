//
//  CSStoryPresenter.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

final class CSStoryPresenter {
    func createStory(name: String) -> Promise<CreateStoryModel> {
        return Promise<CreateStoryModel> { promise in
            firstly {
                return Request(endpoint: Endpoints.createStory, method: .post)
                    .authorise()
                    .set(body: ["name": name])
                    .build()
            }
            .then { (request) -> Promise<CreateStoryModel> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                promise.fulfill(response)
            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
    
    func updateStory(id: Int, name: String) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["name": name])
    }
    
    func updateStory(id: Int, topicId: Int?) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["topic_id": topicId])
    }
    
    func updateStory(id: Int, categoryId: Int?) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["category_id": categoryId])
    }
    
    func updateStory(id: Int, subCategoryId: Int?) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["sub_category_id": subCategoryId])
    }
    
    func updateStory(id: Int, languageId: Int?) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["language_id": languageId])
    }
    
    private func updateStory(id: Int, body: ParametersDict) -> Promise<CreateStoryModel> {
        return Promise<CreateStoryModel> { promise in
            firstly {
                return Request(endpoint: Endpoints.updateCreatedStory(with: id), method: .patch)
                    .authorise()
                    .set(body: body)
                    .build()
            }
            .then { (request) -> Promise<CreateStoryModel> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                promise.fulfill(response)
            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
}
