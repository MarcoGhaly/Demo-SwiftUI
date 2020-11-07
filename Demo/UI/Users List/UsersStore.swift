//
//  UsersStore.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

class UsersStore: LCEViewModel<[User]> {
    
    init() {
        let usersDataSource = UsersDataSource()
        super.init(model: [], publisher: usersDataSource.getAllUsers())
    }
    
}
