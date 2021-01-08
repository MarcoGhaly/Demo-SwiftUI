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
    func getUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAppError>
}

extension UsersDataSource {
    func getUsers() -> AnyPublisher<[User], DefaultAppError> { getUsers(page: nil, limit: nil) }
}
