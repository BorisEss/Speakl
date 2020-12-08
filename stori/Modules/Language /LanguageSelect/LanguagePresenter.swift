//
//  LanguagePresenter.swift
//  stori
//
//  Created by Alex on 08.12.2020.
//

import Foundation
import PromiseKit

class LanguagePresenter {
    func updateLanguages(native: Language,
                         learning: Language,
                         completition: @escaping (_ isSuccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.currentUser, method: .patch)
                .set(body: [
                    "native_lang": native.id,
                    "lang_to_learn": learning.id
                ])
                .authorise()
                .build()
        }
        .then { (request) -> Promise<CurrentUser> in
            return APIClient.request(with: request)
        }
        .done { user in
            Storage.shared.currentUser = user
            completition(true)
        }
        .catch { (error) in
            error.parse()
            completition(false)
        }
    }
}
