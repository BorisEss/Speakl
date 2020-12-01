//
//  RequestProtocol.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation

/// This is the base class for a Request
public protocol RequestProtocol {

    /// This is the endpoint of the request (ie. `/auth/login`)
    var endpoint: URL { get set }
    
    /// The HTTP method used to perform the request.
    var method: RequestMethod { get set }
    
    /// Parameters used to compose the fields dictionary into the url.
    /// They will be automatically converted inside the url.
    /// `null` value wil be ignored automatically; all values must be also represented as `String`,
    /// otherwise will be ignored.
    /// For example `{ "p1" : "abc", "p2" : null, "p3" : 3 }` will be `.../endpoint?p1=abc&p3=3`
    var queryParams: QuerryDict? { get set }
    
    /// Optional headers to append to the request.
    var headers: HeadersDict { get set }
    
    /// The body of the request. Will be encoded based upon the
    var body: ParametersDict? { get set }
    
    /// Initialization of the request with main necessary parameters
    init(endpoint: URL,
         method: RequestMethod)
}
