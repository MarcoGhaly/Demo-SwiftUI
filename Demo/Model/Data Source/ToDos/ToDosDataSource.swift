//
//  ToDosDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class ToDosDataSource: DemoDataSource {
    var methodName: String { "todos" }
    
    var idKey: String { "NextToDoID" }
    
    var subscriptions: [AnyCancellable] = []
    
    func getToDos(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[ToDo], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: methodName, queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
}
