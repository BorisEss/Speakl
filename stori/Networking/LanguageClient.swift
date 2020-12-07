//
//  LanguageClient.swift
//  stori
//
//  Created by Alex on 03.12.2020.
//

import Foundation
import PromiseKit

class LanguageClient {
    static func getLanguages() -> Promise<Void> {
        return Promise<Void> { promise in
            firstly {
                return Request(endpoint: Endpoints.languages)
                    .set(query: [
                        "page_size": "100",
                        "ordering": "id"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<Language>> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                Storage.shared.languages = response.results
                promise.fulfill_()
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
}
