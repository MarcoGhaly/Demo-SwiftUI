//
//  UsersRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 28/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine
import RealmSwift

class UsersRepository: BaseDemoDataSource, UsersDataSource {
    private let nextUserIdKey = "NextUserID"
    
    func getUsers(page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[User], DefaultAppError> {
        var request = Request(url: "users", queryParameters: queryParameters)
        var usersPublisher: AnyPublisher<[User], DefaultAppError> = performRequest(&request, page: page, limit: limit)
        
        if page == 1 {
            if let localUsersPublisher: AnyPublisher<[User], DefaultAppError> = try? DatabaseManager.loadObjects() {
                usersPublisher = Publishers.CombineLatest(usersPublisher, localUsersPublisher).map { remoteUsers, localUsers in
                    localUsers + remoteUsers
                }.eraseToAnyPublisher()
            }
        }
        
        return usersPublisher
    }
    
    func add(user: User) -> AnyPublisher<User, DefaultAppError> {
        add(object: user, method: "users", idKey: nextUserIdKey)
    }
    
    func remove(users: [User]) -> AnyPublisher<Void, DefaultAppError> {
        remove(objects: users, method: "users")
    }
}
