//
//  CSBackgroundSoundPresenter.swift
//  stori
//
//  Created by Alex on 10.02.2021.
//

import Foundation
import PromiseKit

final class CSBackgroundSoundPresenter {
    func getSounds(of subCategory: SubCategory,
                   page: Int = 1) -> Promise<ResponseObject<BackgroundAudio>> {
        return Promise<ResponseObject<BackgroundAudio>> { promise in
            firstly {
                return Request(endpoint: Endpoints.sounds, method: .get)
                    .authorise()
                    .set(query: [
                        "page": "\(page)",
                        "sub_category_id": "\(subCategory.id)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<BackgroundAudio>> in
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
    func getAllSounds(page: Int = 1) -> Promise<ResponseObject<BackgroundAudio>> {
        return Promise<ResponseObject<BackgroundAudio>> { promise in
            firstly {
                return Request(endpoint: Endpoints.sounds, method: .get)
                    .authorise()
                    .set(query: [
                        "page": "\(page)"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<BackgroundAudio>> in
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
    func searchSounds(searchText: String,
                      page: Int = 1) -> Promise<ResponseObject<BackgroundAudio>> {
        return Promise<ResponseObject<BackgroundAudio>> { promise in
            firstly {
                return Request(endpoint: Endpoints.sounds, method: .get)
                    .authorise()
                    .set(query: [
                        "page": "\(page)",
                        "search": searchText
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<BackgroundAudio>> in
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
    
    func createSound(subCategoryId: Int, sound: String, name: String) -> Promise<BackgroundAudio> {
        return Promise<BackgroundAudio> { promise in
            firstly {
                return Request(endpoint: Endpoints.sounds, method: .post)
                    .authorise()
                    .set(body: [
                        "sub_category_id": subCategoryId,
                        "upload_id": sound,
                        "name": ["en": name]
                    ])
                    .build()
            }
            .then { (request) -> Promise<BackgroundAudio> in
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
