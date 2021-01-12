//
//  ToDosViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class ToDosViewModel<DataSource: ToDosDataSource>: BaseLCEListViewModel<ToDo, DataSource> {
    let userID: Int?
    
    init(dataSource: DataSource, userID: Int? = nil, todos: [ToDo]? = nil) {
        self.userID = userID
        super.init(dataSource: dataSource, models: todos, limit: 20)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[ToDo], DefaultAppError> {
        dataSource.getToDos(userID: userID, page: page, limit: limit)
    }
}
