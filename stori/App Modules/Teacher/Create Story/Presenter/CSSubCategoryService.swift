//
//  CSSubCategoryService.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

final class CSSubCategoryService {
    func getSubCategories(of category: Category,
                          with language: Language,
                          page: Int = 1) -> Promise<ResponseObject<SubCategory>> {
        return Promise<ResponseObject<SubCategory>> { promise in
            firstly {
                return Request(endpoint: Endpoints.subCategories, method: .get)
                    .authorise(language: language)
                    .set(query: [
                        "page": "\(page)",
                        "page_size": "20",
                        "category_id": "\(category.id)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<SubCategory>> in
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
    func createSubCategory(categoryId: Int, name: String) -> Promise<SubCategory> {
        return Promise<SubCategory> { promise in
            firstly {
                return Request(endpoint: Endpoints.subCategories, method: .post)
                    .authorise()
                    .set(body: [
                        "category_id": categoryId,
                        "name": [Storage.shared.currentLanguage?.shortcut ?? "en": name]
                    ])
                    .build()
            }
            .then { (request) -> Promise<SubCategory> in
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
