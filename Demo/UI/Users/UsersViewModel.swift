//
//  UsersViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersViewModel<DataSource: UsersDataSource>: BaseLCEListViewModel<User, DataSource> {
    init(dataSource: DataSource, users: [User]? = nil) {
        super.init(dataSource: dataSource, models: users, limit: 5)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[User], DefaultAppError> {
        dataSource.getUsers(page: page, limit: limit)
    }
    
    func add(user: User) {
        add(object: user)
    }
    
    func deleteUsers(wihtIDs usersIDs: Set<User.ID>) {
        deleteObjects(withIDs: usersIDs)
    }
}
