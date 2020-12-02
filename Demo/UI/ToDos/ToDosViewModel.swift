//
//  ToDosViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class ToDosViewModel: LCEListViewModel<ToDo> {
    private var userID: Int?
    
    init(userID: Int? = nil) {
        self.userID = userID
        super.init(limit: 20)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[ToDo], DefaultAppError> {
        DemoDataSource().getToDos(userID: userID, page: page, limit: limit)
    }
}
