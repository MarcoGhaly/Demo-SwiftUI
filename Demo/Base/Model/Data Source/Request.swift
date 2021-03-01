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

enum DatesType {
    case seconds
    case milliseconds
    case iso
}

extension DatesType {
    var encodingStrategy: JSONEncoder.DateEncodingStrategy {
        switch self {
        case .seconds: return .secondsSince1970
        case .milliseconds: return .millisecondsSince1970
        case .iso: return .iso8601
        }
    }
    
    var decodingStrategy: JSONDecoder.DateDecodingStrategy {
        switch self {
        case .seconds: return .secondsSince1970
        case .milliseconds: return .millisecondsSince1970
        case .iso: return .iso8601
        }
    }
}

class Request {
    var httpMethod: HTTPMethod = .GET
    var datesType: DatesType = .iso
    var url: String
    var headers: [String: String]?
    var pathParameters: [String]?
    var queryParameters: [String: String]?
    var body: Data?
    var timeoutInterval: TimeInterval?
    
    init(url: String) {
        self.url = url
    }
    
    func set(httpMethod: HTTPMethod) -> Request {
        self.httpMethod = httpMethod
        return self
    }
    
    func set(datesType: DatesType = .seconds) -> Request {
        self.datesType = datesType
        return self
    }
    
    func set(url: String) -> Request {
        self.url = url
        return self
    }
    
    func set(headers: [String: String]) -> Request {
        self.headers = headers
        return self
    }
    
    func set(pathParameters: [String]) -> Request {
        self.pathParameters = pathParameters
        return self
    }
    
    func set(queryParameters: [String: String]) -> Request {
        self.queryParameters = queryParameters
        return self
    }
    
    func set(body: Data?) -> Request {
        self.body = body
        return self
    }
    
    func set(body: Encodable) -> Request {
        self.body = body.jsonData(datesType: datesType)
        return self
    }
    
    func set(body: [String: String]) -> Request {
        self.body = body.map({ $0 + "=" + $1 }).joined(separator: "&").data(using: .utf8)
        return self
    }
    
    func set(timeoutInterval: TimeInterval) -> Request {
        self.timeoutInterval = timeoutInterval
        return self
    }
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

extension Encodable {
    func jsonData(datesType: DatesType) -> Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = datesType.encodingStrategy
        return try? jsonEncoder.encode(self)
    }
}
