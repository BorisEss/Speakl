//
//  CSStoryService.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

final class CSStoryService {
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
    
    func updateStory(id: Int, topicId: Int?, language: Language? = nil) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["topic_id": topicId], language: language)
    }
    
    func updateStory(id: Int, categoryId: Int?, language: Language? = nil) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["category_id": categoryId], language: language)
    }
    
    func updateStory(id: Int, subCategoryId: Int?, language: Language? = nil) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["sub_category_id": subCategoryId], language: language)
    }
    
    func updateStory(id: Int, languageId: Int?) -> Promise<CreateStoryModel> {
        return updateStory(id: id, body: ["language_id": languageId])
    }
    
    private func updateStory(id: Int, body: ParametersDict, language: Language? = nil) -> Promise<CreateStoryModel> {
        return Promise<CreateStoryModel> { promise in
            firstly {
                return Request(endpoint: Endpoints.updateCreatedStory(with: id), method: .patch)
                    .authorise(language: language)
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
