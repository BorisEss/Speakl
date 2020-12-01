//
//  Commons.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation

/// Define the url querry's dictionary
public typealias QuerryDict = [String: String]

/// Define the parameter's dictionary
public typealias ParametersDict = [String: Any?]

/// Define the header's dictionary
public typealias HeadersDict = [String: String]

/// Define what kind of HTTP method must be used to carry out the `Request`
///
/// - get: get (no body is allowed inside)
/// - post: post
/// - put: put
/// - delete: delete
/// - patch: patch
public enum RequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}
