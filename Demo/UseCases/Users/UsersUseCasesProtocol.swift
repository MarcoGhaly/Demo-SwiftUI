//
//  UsersUseCasesProtocol.swift
//  Demo
//
//  Created by Marco Ghaly on 12.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol UsersUseCasesProtocol: DemoUseCases {
    func getUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAPIError>
    func add(user: User) -> AnyPublisher<User, DefaultAPIError>
    func delete(users: [User]) -> AnyPublisher<Void, DefaultAPIError>
}
