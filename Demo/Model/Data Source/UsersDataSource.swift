//
//  UsersDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersDataSource: BaseDataSource {
    
    func getAllUsers() -> AnyPublisher<[User], AppError> {
        return performRequest(withRelativeURL: "users")
    }
    
}
