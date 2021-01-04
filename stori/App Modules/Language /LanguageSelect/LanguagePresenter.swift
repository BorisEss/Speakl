//
//  LanguagePresenter.swift
//  stori
//
//  Created by Alex on 08.12.2020.
//

import Foundation
import PromiseKit

class LanguagePresenter {
    
    private func updateUser(body: ParametersDict,
                            completion: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.currentUser, method: .patch)
                .set(body: body)
                .authorise()
                .build()
        }
        .then { (request) -> Promise<CurrentUser> in
            return APIClient.request(with: request)
        }
        .done { user in
            Storage.shared.currentUser = user
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
    
    func getSkills() -> Promise<[Skill]> {
        return Promise<[Skill]> { promise in
            firstly {
                return Request(endpoint: Endpoints.skills, method: .get)
                    .authorise()
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<Skill>> in
                return APIClient.request(with: request)
            }
            .done { response in
                promise.fulfill(response.results)
            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
    
    func getLanguageLevels(language: Language) -> Promise<[LanguageLevel]> {
        return Promise<[LanguageLevel]> { promise in
            firstly {
                return Request(endpoint: Endpoints.languageLevel(langId: language.id), method: .get)
                    .authorise()
                    .build()
            }
            .then { (request) -> Promise<[LanguageLevel]> in
                return APIClient.request(with: request)
            }
            .done { levels in
                promise.fulfill(levels)

            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
    
    func getInterests() -> Promise<[Interest]> {
        return Promise<[Interest]> { promise in
            firstly {
                return Request(endpoint: Endpoints.interests, method: .get)
                    .authorise()
                    .set(query: [
                        "page_size": "100"
                    ])
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<Interest>> in
                return APIClient.request(with: request)
            }
            .done { response in
                promise.fulfill(response.results)
            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
    
    func updateLanguageDetails(nativeLanguage: Language?,
                               learningLanguage: Language?,
                               learningLanguageLevel: LanguageLevel?,
                               interests: [Interest],
                               completion: @escaping (_ isSuccess: Bool) -> Void) {
        // TODO: fix this
        if let nativeLanguage = nativeLanguage {
            updateUser(body: ["native_lang_id": nativeLanguage.id]) { _ in
                self.updateLearningLanguage(learningLanguage: learningLanguage,
                                       learningLanguageLevel: learningLanguageLevel,
                                       interests: interests,
                                       completion: completion)
            }
        } else {
            updateLearningLanguage(learningLanguage: learningLanguage,
                                   learningLanguageLevel: learningLanguageLevel,
                                   interests: interests,
                                   completion: completion)
        }
    }
    
    private func updateLearningLanguage(learningLanguage: Language?,
                                        learningLanguageLevel: LanguageLevel?,
                                        interests: [Interest],
                                        completion: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Promise<Void> { promise in
                if let learningLanguage = learningLanguage,
                   let learningLanguageLevel = learningLanguageLevel {
                    self.updateUser(body: [
                        "learn_lang_id": learningLanguage.id,
                        "level_id": learningLanguageLevel.id,
                        "interest_ids": interests.map { $0.id }
                    ]) { _ in
                        promise.fulfill_()
                    }
                } else {
                    promise.fulfill_()
                }
            }
        }
//        .then { _ -> Promise<URLRequest> in
//            return Request(endpoint: Endpoints.updateInterests, method: .post)
//                .set(body: [
//                    "interest_ids": interests.map { $0.id }
//                ])
//                .authorise()
//                .build()
//        }
//        .then { (request) -> Promise<SuccessMessage> in
//            return APIClient.request(with: request)
//        }
//        .then { _ -> Promise<Void> in
//            return UserClient.getCurrentUser()
//        }
        .done { _ in
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
//    func updateLanguages(native: Language,
//                         learning: Language,
//                         completion: @escaping (_ isSuccess: Bool) -> Void) {
//        updateUser(body: [
//            "native_lang": native.id,
//            "lang_to_learn": learning.id
//        ], completion: completion)
//    }
//
//    func updateSkills(skills: [Skill],
//                      completion: @escaping (_ isSuccess: Bool) -> Void) {
//        updateUser(body: [
//            "skill_ids": skills.map { $0.id }
//        ], completion: completion)
//    }
//
//    func updateLearningLanguageLevel(level: LanguageLevel,
//                                     completion: @escaping (_ isSuccess: Bool) -> Void) {
//        updateUser(body: [
//            "lang_to_learn_level": level.id
//        ], completion: completion)
//    }
//
//    func updateInterests(interests: [Interest],
//                         completion: @escaping (_ isSuccess: Bool) -> Void) {
//        firstly {
//            return Request(endpoint: Endpoints.updateInterests, method: .post)
//                .set(body: [
//                    "interest_ids": interests.map { $0.id }
//                ])
//                .authorise()
//                .build()
//        }
//        .then { (request) -> Promise<SuccessMessage> in
//            return APIClient.request(with: request)
//        }
//        .then { _ -> Promise<Void> in
//            return UserClient.getCurrentUser()
//        }
//        .done { _ in
//            completion(true)
//        }
//        .catch { (error) in
//            error.parse()
//            completion(false)
//        }
//    }
}
