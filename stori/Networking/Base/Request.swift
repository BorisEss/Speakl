//
//  Request.swift
//  stori
//
//  Created by Alex on 26.11.2020.
//

import Foundation
import Alamofire
import PromiseKit

public class Request: RequestProtocol {
    
    private var timeout: TimeInterval = 15.0
    
    /// RequestProtocols attributes
    public var endpoint: URL
    public var method: RequestMethod
    public var queryParams: QuerryDict?
    public var headers: HeadersDict = Headers().basic
    public var body: ParametersDict?
    
    /// Class Initialization with default headers
    public required init(endpoint: URL,
                         method: RequestMethod = .get) {
        self.endpoint = endpoint
        self.method = method
    }
    
    /// Adding URL QUerry Parameters
    ///
    /// - Parameter query : Query Dictionary to be converter to URL querry Parameters
    /// - Returns: Current object with new Querry Parameters set
    @discardableResult
    func set(query: QuerryDict) -> Self {
        self.queryParams = query
        return self
    }
    
    /// Adding Headers Parameters Dictionary
    ///
    /// - Parameter headers : Headers Dictionary which will be asigned to the request
    /// - Returns: Current object with new headers
    @discardableResult
    func set(headers: HeadersDict) -> Self {
        self.headers = headers
        return self
    }
    
    /// Adding Body Parameters Dictionary
    ///
    /// - Parameter body : Body Dictionary which will be asigned to the request
    /// - Returns: Current object with new body
    @discardableResult
    func set(body: ParametersDict) -> Self {
        self.body = body
        return self
    }
    
    /// Building the URLRequest for Alamofire.
    ///
    /// - Returns: Promise<URLRequest>
    func build() -> Promise<URLRequest> {
        return Promise { promise in
            var url = endpoint
            if let queryParams = queryParams {
                var urlComps = URLComponents(string: endpoint.absoluteString)!
                urlComps.queryItems = queryParams.map { element in
                    URLQueryItem(name: element.key, value: element.value)
                }
                url = urlComps.url!
            }
            
            var urlRequest = URLRequest(url: url,
                                        cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: timeout)
            urlRequest.httpMethod = method.rawValue
            
            headers.forEach {
                urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            }
            
            do {
                if let body = body {
                    try urlRequest = JSONEncoding.default.encode(urlRequest, with: body as Parameters)
                }
                promise.fulfill(urlRequest)
            } catch {
                promise.reject(NetworkError.requestBuilderFailed)
            }
        }
    }
}
