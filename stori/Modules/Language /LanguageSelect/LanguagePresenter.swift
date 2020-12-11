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
    
    func updateLanguages(native: Language,
                         learning: Language,
                         completion: @escaping (_ isSuccess: Bool) -> Void) {
        updateUser(body: [
            "native_lang": native.id,
            "lang_to_learn": learning.id
        ], completion: completion)
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
    
    func updateSkills(skills: [Skill],
                      completion: @escaping (_ isSuccess: Bool) -> Void) {
        updateUser(body: [
            "skill_ids": skills.map { $0.id }
        ], completion: completion)
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
    
    func updateLearningLanguageLevel(level: LanguageLevel,
                                     completion: @escaping (_ isSuccess: Bool) -> Void) {
        updateUser(body: [
            "lang_to_learn_level": level.id
        ], completion: completion)
    }
}
