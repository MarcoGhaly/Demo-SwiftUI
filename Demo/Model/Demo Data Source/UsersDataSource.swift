//
//  UsersDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct UsersDataSource: DemoDataSource {
    func getAllUsers(page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[User], DefaultAppError> {
        var request = Request(url: "users", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
}
