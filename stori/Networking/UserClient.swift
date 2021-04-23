///
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
                    .authorise()
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
    
    static func updateUserImage(image: UIImage) -> Promise<Void> {
        return Promise<Void> { promise in
            firstly {
                return Request(endpoint: Endpoints.currentUser, method: .patch)
                    .authorise()
                    .build()
            }
            .then { (request) -> Promise<CurrentUser> in
                if let imageData = image.jpegData(compressionQuality: 1) {
                    return APIClient.upload(to: request, data: [
                        "avatar": imageData
                    ], type: .image) { (progress) in
                        #if DEBUG
                        print(progress)
                        #endif
                    }
                } else {
                    return.init(error: NetworkError.requestBuilderFailed)
                }
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
    
    static func verifySubscription(receipt: String) -> Promise<Void> {
        return Promise<Void> { promise in
            firstly {
                return Request(endpoint: Endpoints.verifyReceipt, method: .post)
                    .set(headers: Headers().authorized)
                    .set(body: [
                        "receipt": receipt
                    ])
                    .build()
            }
            .then { (request) -> Promise<DiscardableResponse> in
                return APIClient.request(with: request)
            }
            .then({ (_) -> Promise<Void> in
                return UserClient.getCurrentUser()
            })
            .done { (_) in
                promise.fulfill_()
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
}
