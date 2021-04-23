//
//  JoinTNPresenter.swift
//  stori
//
//  Created by Alex on 14.01.2021.
//

import Foundation
import PromiseKit

class JoinTNPresenter {
    func join(personalId: [LocalFile],
              documentId: [LocalFile],
              selfie: [LocalFile],
              type: JoinTNUserType,
              completion: @escaping (_ isSucccess: Bool) -> Void) {
        firstly {
            return Request(endpoint: Endpoints.joinTN, method: .post)
                .set(body: [
                    "personal_ids": personalId.compactMap({ $0.id }),
                    "document_ids": documentId.compactMap({ $0.id }),
                    "selfies": selfie.compactMap({ $0.id }),
                    "type": type.rawValue
                ])
                .authorise()
                .build()
        }
        .then { (request) -> Promise<DiscardableResponse> in
            return APIClient.request(with: request)
        }
        .then { (_) -> Promise<Void> in
            return UserClient.getCurrentUser()
        }
        .done { _ in
            completion(true)
        }
        .catch { (error) in
            error.parse()
            completion(false)
        }
    }
}
