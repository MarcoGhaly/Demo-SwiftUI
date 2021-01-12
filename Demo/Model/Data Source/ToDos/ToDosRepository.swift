//
//  ToDosRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 12/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class ToDosRepository: ToDosDataSource {
    var methodName: String { "todos" }
    
    var idKey: String { "NextToDoID" }
    
    var subscriptions: [AnyCancellable] = []
    
    func getToDos(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[ToDo], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return getData(queryParameters: queryParameters, page: page, limit: limit)
    }
}
