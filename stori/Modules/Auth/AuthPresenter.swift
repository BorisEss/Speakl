//
//  AuthPresenter.swift
//  stori
//
//  Created by Alex on 25.11.2020.
//

import Foundation
import PromiseKit

class AuthPresenter {
    
    func logIn(email: String,
               password: String,
               completition: @escaping (_ isSucccess: Bool) -> Void) {
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
        .then { (model) -> Promise<URLRequest>  in
            KeychainManager.shared.token = model.token
            return Request(endpoint: Endpoints.currentUser)
                .set(headers: Headers().authorized)
                .build()
        }
        .then { (request) -> Promise<CurrentUser> in
            return APIClient.request(with: request)
        }
        .done { (value) in
            CurrentUser.shared = value
            completition(true)
        }
        .catch { (error) in
            error.parse()
            completition(false)
        }
    }
    
    func signUp(username: String,
                email: String,
                password: String,
                completition: @escaping (_ isSucccess: Bool) -> Void) {
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
        .then { (model) -> Promise<URLRequest>  in
            KeychainManager.shared.token = model.token
            return Request(endpoint: Endpoints.currentUser)
                .set(headers: Headers().authorized)
                .build()
        }
        .then { (request) -> Promise<CurrentUser> in
            return APIClient.request(with: request)
        }
        .done { (value) in
            CurrentUser.shared = value
            completition(true)
        }
        .catch { (error) in
            error.parse()
            completition(false)
        }
    }
    
    func forgotPassword(email: String,
                        completition: @escaping (_ isSuccess: Bool) -> Void) {
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
            completition(true)
        }
        .catch { (error) in
            error.parse()
            completition(false)
        }
    }
    
    func resetPassword(code: String,
                       password: String,
                       completition: @escaping (_ isSuccess: Bool) -> Void) {
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
            completition(true)
        }
        .catch { (error) in
            error.parse()
            completition(false)
        }
    }
    
    func facebookAuth(token: String,
                      completition: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.facebookLogin, method: .post)
                .set(body: [
                    "access_token": token
                ]).build()
        }
        .then { (request) -> Promise<AuthModel> in
            return APIClient.request(with: request)
        }
        .then { (model) -> Promise<URLRequest>  in
            KeychainManager.shared.token = model.token
            return Request(endpoint: Endpoints.currentUser)
                .set(headers: Headers().authorized)
                .build()
        }
        .then { (request) -> Promise<CurrentUser> in
            return APIClient.request(with: request)
        }
        .done { (value) in
            CurrentUser.shared = value
            completition(true)
        }
        .catch { (error) in
            error.parse()
            completition(false)
        }
    }
    
    func googleAuth(token: String,
                    completition: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.googleLogin, method: .post)
                .set(body: [
                    "access_token": token
                ]).build()
        }
        .then { (request) -> Promise<AuthModel> in
            return APIClient.request(with: request)
        }
        .then { (model) -> Promise<URLRequest>  in
            KeychainManager.shared.token = model.token
            return Request(endpoint: Endpoints.currentUser)
                .set(headers: Headers().authorized)
                .build()
        }
        .then { (request) -> Promise<CurrentUser> in
            return APIClient.request(with: request)
        }
        .done { (value) in
            CurrentUser.shared = value
            completition(true)
        }
        .catch { (error) in
            error.parse()
            completition(false)
        }
    }
    
    func appleAuth(name: String?,
                   code: String,
                   completition: @escaping (_ isSuccess: Bool) -> Void) {
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
        .then { (model) -> Promise<URLRequest>  in
            KeychainManager.shared.token = model.token
            return Request(endpoint: Endpoints.currentUser)
                .set(headers: Headers().authorized)
                .build()
        }
        .then { (request) -> Promise<CurrentUser> in
            return APIClient.request(with: request)
        }
        .done { (value) in
            CurrentUser.shared = value
            completition(true)
        }
        .catch { (error) in
            error.parse()
            completition(false)
        }
    }
}
