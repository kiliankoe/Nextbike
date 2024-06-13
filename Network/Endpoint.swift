//
//  Endpoint.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?
    let queryItems: [URLQueryItem]?
    
    var url: URL {
        var components = URLComponents(string: "https://api.nextbike.net\(path)")!
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        return components.url!
    }
    
    init(path: String, method: HTTPMethod = .GET, headers: [String: String]? = nil, body: Data? = nil, queryItems: [URLQueryItem]? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.queryItems = queryItems
    }
}
