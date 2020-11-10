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
    
    func getToDos() -> AnyPublisher<[ToDo], DefaultAppError> {
        let urlString = "todos"
        return performRequest(withRelativeURL: urlString)
    }
    
}
