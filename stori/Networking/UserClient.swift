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
    
    static func updateUsername(username: String) -> Promise<Void> {
        return updateUserData(body: [ "username": username ])
    }
    
    static func changePassword(oldPassword: String,
                               newPassword: String) -> Promise<Void> {
        return Promise<Void> { promise in
            firstly {
                return Request(endpoint: Endpoints.changePassword, method: .post)
                    .set(headers: Headers().authorized)
                    .set(body: [
                        "old_password": oldPassword,
                        "password": newPassword,
                        "password_c": newPassword
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
    
    static func updateNotifications(enabled: Bool) -> Promise<Void> {
        return updateUserData(body: [ "receive_notifications": enabled ])
    }
    
    private static func updateUserData(body: ParametersDict) -> Promise<Void> {
        return Promise<Void> { promise in
            firstly {
                return Request(endpoint: Endpoints.currentUser, method: .patch)
                    .set(headers: Headers().authorized)
                    .set(body: body)
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
