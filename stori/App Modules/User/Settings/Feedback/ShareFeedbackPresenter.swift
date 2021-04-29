//
//  ShareFeedbackPresenter.swift
//  stori
//
//  Created by Alex on 27.04.2021.
//

import Foundation
import PromiseKit

class ShareFeedbackPresenter {
    static func sendFeedback(rating: Int, message: String) -> Promise<Void> {
        return Promise<Void> { promise in
            firstly {
                return Request(endpoint: Endpoints.feedback, method: .post)
                    .set(headers: Headers().authorized)
                    .set(body: [
                        "rate": rating,
                        "text": message
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
        }
    }
}
