//
//  ToDosDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct ToDosDataSource: BaseDataSource {
    
    func getToDos(userID: Int? = nil) -> AnyPublisher<[ToDo], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        let request = Request(url: "todos", queryParameters: queryParameters)
        return performRequest(request)
    }
    
}
