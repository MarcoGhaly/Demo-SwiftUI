//
//  UsersRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 28/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersRepository: UsersDataSource {
    var methodName: String { "users" }
    
    var idKey: String { "NextUserID" }
    
    var subscriptions: [AnyCancellable] = []
    
    func getUsers(page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[User], DefaultAPIError> {
        let publisher: AnyPublisher<[User], DefaultAPIError> = getData(page: page, limit: limit)
        return publisher.map { users in
            let coordinates = UsersRepository.coordinates
            var counter = 0
            users.forEach { user in
                user.address?.geo = coordinates[counter % coordinates.count]
                counter += 1
            }
            return users
        }
        .eraseToAnyPublisher()
    }
    
    private static let coordinates = [(29.979250, 31.134222), // Great Pyramid at Giza
                                      (40.689250, -74.044444), // Statue of Liberty
                                      (48.858361, 2.294444), // Eiffel Tower
                                      (55.752500, 37.623056), // St. Basil's Cathedral
                                      (41.005389, 28.976778), // Blue Mosque
                                      (27.175056, 78.042111), // Taj Mahal
                                      (37.820111, -122.478278), // Golden Gate Bridge
                                      (38.624639, -90.184806), // Gateway Arch
                                      (52.516250, 13.377667), // Brandenburg Gate
                                      (25.197167, 55.274361)] // Burj Khalifa
        .map {
            Geo(lat: String($0.0), lng: String($0.1))
        }
}
