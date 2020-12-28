//
//  UsersDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol UsersDataSource: DemoDataSource {
    func getAllUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAppError>
    func add(user: User) -> AnyPublisher<User, DefaultAppError>
    func remove(users: [User]) -> AnyPublisher<Void, DefaultAppError>
}

extension UsersDataSource {
    func getAllUsers() -> AnyPublisher<[User], DefaultAppError> { getAllUsers(page: nil, limit: nil) }
    func getAllUsers(page: Int?) -> AnyPublisher<[User], DefaultAppError> { getAllUsers(page: page, limit: nil) }
    func getAllUsers(limit: Int?) -> AnyPublisher<[User], DefaultAppError> { getAllUsers(page: nil, limit: limit)}
}
