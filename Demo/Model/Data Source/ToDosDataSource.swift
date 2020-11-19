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
        var urlString = "todos"
        userID.map { urlString += "?userId=\($0)" }
        return performRequest(withRelativeURL: urlString)
    }
    
}
