//
//  RedeemPresenter.swift
//  stori
//
//  Created by Alex on 29.04.2021.
//

import Foundation
import PromiseKit

class RedeemPresenter {
    static func redeemCode(code: String) -> Promise<Void> {
        return Promise<Void> { promise in
            firstly {
                return Request(endpoint: Endpoints.redeemCode, method: .post)
                    .set(headers: Headers().authorized)
                    .set(body: [
                        "code": code
                    ])
                    .build()
            }
            .then { (request) -> Promise<DiscardableResponse> in
                return APIClient.request(with: request)
            }
            .done { (_) in
                promise.fulfill_()
            }
            .catch { (error) in
                promise.reject(error)
            }
            promise.fulfill_()
        }
    }
}
