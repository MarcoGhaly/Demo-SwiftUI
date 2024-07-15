//
//  UsersRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 10.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersRepository: UsersDataSource {
    let networkAgent: NetworkAgentProtocol
    var methodName: String { "users" }
    
    init(networkAgent: NetworkAgentProtocol = NetworkAgent()) {
        self.networkAgent = networkAgent
    }

    func getRemoteUsers(page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[User], DefaultAPIError> {
        getRemoteData(page: page, limit: limit)
    }
    
    func getLocalUsers() -> AnyPublisher<[User], DefaultAPIError> {
        getLocalData()
    }
}
