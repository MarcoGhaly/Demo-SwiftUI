//
//  UsersUseCase.swift
//  Demo
//
//  Created by Marco Ghaly on 17.07.22.
//  Copyright © 2022 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersUseCases: UsersUseCasesProtocol {
    var idKey: String { "NextUserID" }
    
    let dataSource: UsersDataSource
    
    var subscriptions = [AnyCancellable]()
    
    init(dataSource: UsersDataSource = UsersRepository()) {
        self.dataSource = dataSource
    }
    
    func getUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAPIError> {
        var publisher: AnyPublisher<[User], DefaultAPIError> = dataSource.getRemoteUsers(page: page, limit: limit)
        publisher = addCoordinates(to: publisher)
        
        if page == 1 {
            let localPublisher: AnyPublisher<[User], DefaultAPIError> = dataSource.getLocalUsers()
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remoteUsers, localUsers in
                localUsers + remoteUsers
            }.eraseToAnyPublisher()
        }
        
        return publisher
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(user: User) -> AnyPublisher<User, DefaultAPIError> {
        let publisher: AnyPublisher<ID, DefaultAPIError> = dataSource.addRemote(object: user)
        return publisher.map { [weak self] id in
            guard let self else { return user }
            let id = id.id ?? 1
            user.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: user) ?? user
        }
        .eraseToAnyPublisher()
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func delete(users: [User]) -> AnyPublisher<Void, DefaultAPIError> {
        let publishers: [AnyPublisher<Void, DefaultAPIError>] = users.map { user in
            let publisher: AnyPublisher<EmptyResponse, DefaultAPIError> = dataSource.deleteRemote(object: user)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: User? = self.dataSource.deleteLocal(object: user)
            }
            .store(in: &subscriptions)
            
            return publisher.map { _ in () }
            .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .reduce((), { (_, _) in () })
            .eraseToAnyPublisher()
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

private extension UsersUseCases {
    func addCoordinates(to publisher: AnyPublisher<[User], DefaultAPIError>) -> AnyPublisher<[User], DefaultAPIError> {
        publisher.map { users in
            let coordinates = Self.coordinates
            var counter = 0
            users.forEach { user in
                user.address?.geo = coordinates[counter % coordinates.count]
                counter += 1
            }
            return users
        }
        .eraseToAnyPublisher()
    }
}

private extension UsersUseCases {
    static let coordinates = [
        (29.979250, 31.134222), // Great Pyramid at Giza
        (40.689250, -74.044444), // Statue of Liberty
        (48.858361, 2.294444), // Eiffel Tower
        (55.752500, 37.623056), // St. Basil's Cathedral
        (41.005389, 28.976778), // Blue Mosque
        (27.175056, 78.042111), // Taj Mahal
        (37.820111, -122.478278), // Golden Gate Bridge
        (38.624639, -90.184806), // Gateway Arch
        (52.516250, 13.377667), // Brandenburg Gate
        (25.197167, 55.274361) // Burj Khalifa
    ].map { Geo(lat: String($0.0), lng: String($0.1)) }
}
