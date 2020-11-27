//
//  UsersDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct UsersDataSource: BaseDataSource {
    
    func getAllUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAppError> {
        var urlString = "users"
        if let page = page, let limit = limit {
            urlString += "?_page=\(page)&_limit=\(limit)"
        }
        return performRequest(withRelativeURL: urlString)
    }
    
}
