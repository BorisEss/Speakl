//
//  UserClient.swift
//  stori
//
//  Created by Alex on 03.12.2020.
//

import Foundation
import PromiseKit

class UserClient {
    static func getCurrentUser() -> Promise<Void> {
        return Promise<Void> { promise in
            firstly {
                return Request(endpoint: Endpoints.currentUser)
                    .set(headers: Headers().authorized)
                    .build()
            }
            .then { (request) -> Promise<CurrentUser> in
                return APIClient.request(with: request)
            }
            .done { (user) in
                Storage.shared.currentUser = user
                promise.fulfill_()
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
}
