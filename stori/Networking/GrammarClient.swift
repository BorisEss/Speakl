//
//  GrammarClient.swift
//  stori
//
//  Created by Alex on 04.05.2021.
//

import Foundation
import PromiseKit

class GrammarClient {
    func getGrammar(query: QuerryDict) -> Promise<String> {
        return Promise<String> { promise in
            firstly {
                return Request(endpoint: Endpoints.grammar, method: .get)
                    .authorise()
                    .set(query: query)
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<Grammar>> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                guard let firstResult = response.results.first else {
                    promise.reject(NetworkError.notFound)
                    return
                }
                promise.fulfill(firstResult.url)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
}
