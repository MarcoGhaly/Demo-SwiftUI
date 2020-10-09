//
//  ToDosDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class ToDosDataSource: BaseDataSource {
    
    func getToDos() -> AnyPublisher<[ToDo], AppError> {
        let urlString = "todos"
        return performRequest(withRelativeURL: urlString)
    }
    
}
