//
//  AuthService.swift
//  stori
//
//  Created by Alex on 25.11.2020.
//

import Foundation
import PromiseKit

class AuthService {
    
    func logIn(email: String,
               password: String,
               completion: @escaping (_ isSucccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.login, method: .post)
                .set(body: [
                    "email": email,
                    "password": password
                ]).build()
        }
        .then { (request) -> Promise<AuthModel> in
            return APIClient.request(with: request)
        }
        .done { (model) in
            KeychainManager.shared.token = model.token
            Storage.shared.currentUser = model.user
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    func signUp(username: String,
                email: String,
                password: String,
                completion: @escaping (_ isSucccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.register, method: .post)
                .set(body: [
                    "email": email,
                    "username": username,
                    "password": password,
                    "password_c": password
                ]).build()
        }
        .then { (request) -> Promise<AuthModel> in
            return APIClient.request(with: request)
        }
        .done { (model) in
            KeychainManager.shared.token = model.token
            Storage.shared.currentUser = model.user
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    func forgotPassword(email: String,
                        completion: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.requestResetPassword, method: .post)
                .set(body: [
                    "email": email
                ]).build()
        }
        .then { (request) -> Promise<MessageObject> in
            APIClient.request(with: request)
        }
        .done { (_) in
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    func resetPassword(code: String,
                       password: String,
                       completion: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.resetPassword, method: .post)
                .set(body: [
                    "code": code,
                    "password": password,
                    "password_c": password
                ]).build()
        }
        .then { (request) -> Promise<MessageObject> in
            APIClient.request(with: request)
        }
        .done { (_) in
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    func facebookAuth(token: String,
                      completion: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.facebookLogin, method: .post)
                .set(body: [
                    "access_token": token
                ]).build()
        }
        .then { (request) -> Promise<AuthModel> in
            return APIClient.request(with: request)
        }
        .done { (model) in
            KeychainManager.shared.token = model.token
            Storage.shared.currentUser = model.user
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    func googleAuth(token: String,
                    completion: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.googleLogin, method: .post)
                .set(body: [
                    "access_token": token
                ]).build()
        }
        .then { (request) -> Promise<AuthModel> in
            return APIClient.request(with: request)
        }
        .done { (model) in
            KeychainManager.shared.token = model.token
            Storage.shared.currentUser = model.user
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    func appleAuth(name: String?,
                   code: String,
                   completion: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.appleLogin, method: .post)
                .set(body: [
                    "code": code,
                    "name": name
                ]).build()
        }
        .then { (request) -> Promise<AuthModel> in
            return APIClient.request(with: request)
        }
        .done { (model) in
            KeychainManager.shared.token = model.token
            Storage.shared.currentUser = model.user
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
}
