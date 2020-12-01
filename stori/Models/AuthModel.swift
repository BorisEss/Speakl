//
//  AuthModel.swift
//  stori
//
//  Created by Alex on 30.11.2020.
//

import Foundation

struct AuthModel: Decodable {
    var token: String
    var user: AuthUser
}
