//
//  UsersDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersDataSource: DemoDataSource {
    private let nextUserIdKey = "NextUserID"
    private var subscriptions: [AnyCancellable] = []
    
    func getAllUsers(page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[User], DefaultAppError> {
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
        let request = Request(httpMethod: .POST, url: "users", body: user)
        let publisher: AnyPublisher<ID, DefaultAppError> = performRequest(request)
        return publisher.map { id in
            user.id = self.getNextUserID(withInitialValue: id.id) ?? 0
            return (try? DatabaseManager.save(object: user)) ?? user
        }.eraseToAnyPublisher()
    }
    
    private func getNextUserID(withInitialValue userID: Int?) -> Int? {
        guard let userID: Int = UserDefaultsManager.loadValue(forKey: nextUserIdKey) ?? userID else { return nil }
        UserDefaultsManager.save(value: userID + 1, forKey: nextUserIdKey)
        return userID
    }
    
    func remove(users: [User]) -> AnyPublisher<Void, DefaultAppError> {
        let publishers: [AnyPublisher<Void, DefaultAppError>] = users.map { user in
            let request = Request(httpMethod: .DELETE, url: "users", pathParameters: [String(user.id)])
            let publisher: AnyPublisher<EmptyResponse, DefaultAppError> = performRequest(request)
            
            publisher.sink { _ in
            } receiveValue: { response in
                let predicate = NSPredicate(format: "id = %@", argumentArray: users.map { $0.id })
                let _: [User]? = try? DatabaseManager.deleteObjects(predicate: predicate)
            }
            .store(in: &subscriptions)
            
            return publisher.map { _ in () }
            .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .reduce((), { (_, _) in () })
            .eraseToAnyPublisher()
    }
}
