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
}
