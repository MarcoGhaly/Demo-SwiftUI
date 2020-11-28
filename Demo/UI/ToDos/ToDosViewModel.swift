//
//  ToDosViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class ToDosViewModel: LCEViewModel<[ToDo]> {
    
    private var userID: Int?
    
    init(userID: Int? = nil) {
        self.userID = userID
    }
    
    override func dataPublisher() -> AnyPublisher<[ToDo], DefaultAppError> {
        DemoDataSource().getToDos(userID: userID)
    }
    
}
