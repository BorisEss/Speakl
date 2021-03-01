//
//  CSCoverPresenter.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

final class CSCoverPresenter {
    func getCovers(of subCategory: SubCategory,
                   page: Int = 1) -> Promise<ResponseObject<CoverImage>> {
        return Promise<ResponseObject<CoverImage>> { promise in
            firstly {
                return Request(endpoint: Endpoints.covers, method: .get)
                    .authorise()
                    .set(query: [
                        "page": "\(page)",
                        "sub_category_id": "\(subCategory.id)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<CoverImage>> in
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
    func createCover(subCategoryId: Int, cover: String) -> Promise<CoverImage> {
        return Promise<CoverImage> { promise in
            firstly {
                return Request(endpoint: Endpoints.covers, method: .post)
                    .authorise()
                    .set(body: [
                        "sub_category_id": subCategoryId,
                        "upload_id": cover
                    ])
                    .build()
            }
            .then { (request) -> Promise<CoverImage> in
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
