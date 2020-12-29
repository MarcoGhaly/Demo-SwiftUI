//
//  DemoDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 28/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol DemoDataSource: BaseDataSource {
}

extension DemoDataSource {
    var baseURL: String { "https://jsonplaceholder.typicode.com/" }
    var queryParameters: [String: String]? { ["_limit": String(5)] }
}

extension DemoDataSource {
    func performRequest<DataModel: Codable, ErrorModel: Codable>(_ request: inout Request, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<DataModel, AppError<ErrorModel>> {
        var queryParameters = request.queryParameters ?? [:]
        page.map { queryParameters["_page"] = String($0) }
        limit.map { queryParameters["_limit"] = String($0) }
        
        request.queryParameters = queryParameters
        return performRequest(request)
    }
}
