//
//  Request.swift
//  Demo
//
//  Created by Marco Ghaly on 27/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

struct Request {
    var httpMethod: HTTPMethod = .GET
    var url: String
    var headers: [String: String]?
    var pathParameters: [String]?
    var queryParameters: [String: String]?
    var body: Encodable?
    var timeoutInterval: TimeInterval?
}

extension Request {
    var formattedURL: String {
        var url = self.url
        formattedPathParameters.map { url += $0 }
        formattedQueryParameters.map { url += $0 }
        return url
    }
    
    var formattedPathParameters: String? {
        guard var pathParameters = self.pathParameters?.joined(separator: "/") else { return nil }
        if !pathParameters.isEmpty {
            pathParameters = "/" + pathParameters
        }
        return pathParameters
    }
    
    var formattedQueryParameters: String? {
        guard var queryParameters = self.queryParameters?.map({ $0 + "=" + $1 }).joined(separator: "&") else { return nil }
        if !queryParameters.isEmpty {
            queryParameters = "?" + queryParameters
        }
        return queryParameters
    }
}
