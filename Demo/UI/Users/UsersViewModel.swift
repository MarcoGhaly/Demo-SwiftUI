//
//  UsersViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersViewModel: LCEListViewModel<User> {
    init() {
        super.init(limit: 5)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[User], DefaultAppError> {
        UsersDataSource().getAllUsers(page: page, limit: limit)
    }
}
